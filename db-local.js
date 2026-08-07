/**
 * Local Database Module - IndexedDB Wrapper
 * Provides complete offline-first data persistence with sync capabilities
 * No external dependencies, works 100% offline
 */

class LocalDB {
  constructor(dbName = 'CreatorHub', version = 1) {
    this.dbName = dbName;
    this.version = version;
    this.db = null;
    this.syncQueue = [];
    this.isOnline = navigator.onLine;
    this.listeners = {};
  }

  /**
   * Initialize the database
   */
  async init() {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.dbName, this.version);

      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.db = request.result;
        console.log('✓ Local database initialized');
        resolve(this.db);
      };

      request.onupgradeneeded = (event) => {
        const db = event.target.result;
        this.createStores(db);
      };
    });
  }

  /**
   * Create object stores for different data types
   */
  createStores(db) {
    const stores = [
      { name: 'products', keyPath: 'id' },
      { name: 'sales', keyPath: 'id' },
      { name: 'licenses', keyPath: 'key' },
      { name: 'shops', keyPath: 'id' },
      { name: 'customers', keyPath: 'id' },
      { name: 'settings', keyPath: 'key' },
      { name: 'syncQueue', keyPath: 'id', autoIncrement: true },
      { name: 'cache', keyPath: 'key' }
    ];

    stores.forEach(store => {
      if (!db.objectStoreNames.contains(store.name)) {
        const os = db.createObjectStore(store.name, { 
          keyPath: store.keyPath,
          autoIncrement: store.autoIncrement 
        });
        
        // Create indexes
        if (store.name === 'products') {
          os.createIndex('shopId', 'shopId', { unique: false });
          os.createIndex('createdAt', 'createdAt', { unique: false });
        }
        if (store.name === 'sales') {
          os.createIndex('productId', 'productId', { unique: false });
          os.createIndex('date', 'date', { unique: false });
        }
        if (store.name === 'customers') {
          os.createIndex('email', 'email', { unique: false });
        }
      }
    });
  }

  /**
   * Add or update data
   */
  async put(storeName, data) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([storeName], 'readwrite');
      const store = transaction.objectStore(storeName);
      const request = store.put(data);

      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.emit('data-changed', { storeName, action: 'put', data });
        resolve(request.result);
      };
    });
  }

  /**
   * Get single item
   */
  async get(storeName, key) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([storeName], 'readonly');
      const store = transaction.objectStore(storeName);
      const request = store.get(key);

      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve(request.result);
    });
  }

  /**
   * Get all items from a store
   */
  async getAll(storeName) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([storeName], 'readonly');
      const store = transaction.objectStore(storeName);
      const request = store.getAll();

      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve(request.result);
    });
  }

  /**
   * Query by index
   */
  async query(storeName, indexName, value) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([storeName], 'readonly');
      const store = transaction.objectStore(storeName);
      const index = store.index(indexName);
      const request = index.getAll(value);

      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve(request.result);
    });
  }

  /**
   * Delete item
   */
  async delete(storeName, key) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([storeName], 'readwrite');
      const store = transaction.objectStore(storeName);
      const request = store.delete(key);

      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.emit('data-changed', { storeName, action: 'delete', key });
        resolve();
      };
    });
  }

  /**
   * Clear entire store
   */
  async clear(storeName) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([storeName], 'readwrite');
      const store = transaction.objectStore(storeName);
      const request = store.clear();

      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve();
    });
  }

  /**
   * Batch operations
   */
  async batch(storeName, operations) {
    const transaction = this.db.transaction([storeName], 'readwrite');
    const store = transaction.objectStore(storeName);
    const results = [];

    return new Promise((resolve, reject) => {
      operations.forEach((op, index) => {
        let request;
        if (op.action === 'put') {
          request = store.put(op.data);
        } else if (op.action === 'delete') {
          request = store.delete(op.key);
        }

        request.onerror = () => reject(request.error);
        request.onsuccess = () => {
          results.push(request.result);
          if (results.length === operations.length) {
            resolve(results);
          }
        };
      });
    });
  }

  /**
   * Add to sync queue for later sync
   */
  async addToSyncQueue(action, storeName, data) {
    const queueItem = {
      action,
      storeName,
      data,
      timestamp: Date.now(),
      status: 'pending'
    };

    return this.put('syncQueue', queueItem);
  }

  /**
   * Get pending sync items
   */
  async getSyncQueue() {
    return this.getAll('syncQueue');
  }

  /**
   * Mark sync item as complete
   */
  async markSyncComplete(id) {
    const item = await this.get('syncQueue', id);
    if (item) {
      item.status = 'synced';
      item.syncedAt = Date.now();
      await this.put('syncQueue', item);
    }
  }

  /**
   * Clear sync queue
   */
  async clearSyncQueue() {
    return this.clear('syncQueue');
  }

  /**
   * Export all data as JSON
   */
  async exportData() {
    const stores = ['products', 'sales', 'licenses', 'shops', 'customers', 'settings'];
    const exportData = {};

    for (const storeName of stores) {
      exportData[storeName] = await this.getAll(storeName);
    }

    return {
      version: this.version,
      exportedAt: new Date().toISOString(),
      data: exportData
    };
  }

  /**
   * Import data from JSON
   */
  async importData(importData) {
    const stores = ['products', 'sales', 'licenses', 'shops', 'customers', 'settings'];

    for (const storeName of stores) {
      if (importData.data[storeName]) {
        await this.clear(storeName);
        const operations = importData.data[storeName].map(item => ({
          action: 'put',
          data: item
        }));
        await this.batch(storeName, operations);
      }
    }

    console.log('✓ Data imported successfully');
  }

  /**
   * Get database statistics
   */
  async getStats() {
    const stores = ['products', 'sales', 'licenses', 'shops', 'customers'];
    const stats = {};

    for (const storeName of stores) {
      const items = await this.getAll(storeName);
      stats[storeName] = {
        count: items.length,
        size: JSON.stringify(items).length
      };
    }

    return stats;
  }

  /**
   * Event listener system
   */
  on(event, callback) {
    if (!this.listeners[event]) {
      this.listeners[event] = [];
    }
    this.listeners[event].push(callback);
  }

  emit(event, data) {
    if (this.listeners[event]) {
      this.listeners[event].forEach(callback => callback(data));
    }
  }

  /**
   * Monitor online/offline status
   */
  setupConnectivityMonitor() {
    window.addEventListener('online', () => {
      this.isOnline = true;
      console.log('✓ Back online');
      this.emit('online', {});
    });

    window.addEventListener('offline', () => {
      this.isOnline = false;
      console.log('✗ Went offline');
      this.emit('offline', {});
    });
  }
}

// Export for use
if (typeof module !== 'undefined' && module.exports) {
  module.exports = LocalDB;
}
