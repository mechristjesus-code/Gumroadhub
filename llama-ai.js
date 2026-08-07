/**
 * Gumroad Creator Hub - Lightweight Llama AI Integration
 * Uses Ollama with TinyLlama (1.1B parameters) for minimal phone resource usage
 * 
 * Setup:
 * 1. Install Ollama: https://ollama.ai
 * 2. Pull TinyLlama: ollama pull tinyllama
 * 3. Start Ollama: ollama serve (default port 11434)
 * 4. Access via: http://localhost:11434
 */

class LlamaAI {
  constructor(config = {}) {
    this.apiUrl = config.apiUrl || 'http://localhost:11434/api';
    this.model = config.model || 'tinyllama';
    this.temperature = config.temperature || 0.7;
    this.topP = config.topP || 0.9;
    this.topK = config.topK || 40;
    this.maxTokens = config.maxTokens || 256; // Keep low for phone efficiency
    this.isAvailable = false;
    this.checkAvailability();
  }

  /**
   * Check if Ollama service is running
   */
  async checkAvailability() {
    try {
      const response = await fetch(`${this.apiUrl.replace('/api', '')}/tags`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
      });
      this.isAvailable = response.ok;
      if (this.isAvailable) {
        console.log('✓ Llama AI service is available');
      }
    } catch (error) {
      console.log('⚠ Llama AI service not available. Install Ollama and run: ollama pull tinyllama');
      this.isAvailable = false;
    }
  }

  /**
   * Generate text using Llama
   * @param {string} prompt - The input prompt
   * @param {boolean} stream - Whether to stream response
   * @returns {Promise<string>} Generated text
   */
  async generate(prompt, stream = false) {
    if (!this.isAvailable) {
      return 'Llama AI service not available. Please install Ollama and run: ollama pull tinyllama';
    }

    try {
      const response = await fetch(`${this.apiUrl}/generate`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          model: this.model,
          prompt: prompt,
          stream: stream,
          temperature: this.temperature,
          top_p: this.topP,
          top_k: this.topK,
          num_predict: this.maxTokens
        })
      });

      if (!response.ok) {
        throw new Error(`API error: ${response.statusText}`);
      }

      if (stream) {
        return this.handleStreamResponse(response);
      } else {
        const data = await response.json();
        return data.response || '';
      }
    } catch (error) {
      console.error('Llama AI error:', error);
      return `Error: ${error.message}`;
    }
  }

  /**
   * Handle streaming response
   */
  async handleStreamResponse(response) {
    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let fullResponse = '';

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        const chunk = decoder.decode(value);
        const lines = chunk.split('\n').filter(line => line.trim());

        for (const line of lines) {
          try {
            const json = JSON.parse(line);
            if (json.response) {
              fullResponse += json.response;
            }
          } catch (e) {
            // Skip invalid JSON lines
          }
        }
      }
    } finally {
      reader.releaseLock();
    }

    return fullResponse;
  }

  /**
   * Generate product description
   */
  async generateProductDescription(productName, productCategory) {
    const prompt = `Generate a compelling product description for an online store. Product: ${productName}, Category: ${productCategory}. Keep it under 100 words.`;
    return this.generate(prompt);
  }

  /**
   * Generate product title variations
   */
  async generateProductTitles(productDescription) {
    const prompt = `Generate 3 catchy product titles based on this description: "${productDescription}". Format as a numbered list.`;
    return this.generate(prompt);
  }

  /**
   * Enhance text (for ebook creator)
   */
  async enhanceText(text) {
    const prompt = `Improve this text for clarity and engagement:\n\n${text}\n\nProvide only the improved text without explanation.`;
    return this.generate(prompt);
  }

  /**
   * Generate writing suggestions
   */
  async getWritingSuggestion(text) {
    const prompt = `Provide one writing suggestion to improve this text:\n\n${text}\n\nKeep suggestion under 50 words.`;
    return this.generate(prompt);
  }

  /**
   * Analyze customer sentiment (simple)
   */
  async analyzeSentiment(text) {
    const prompt = `Analyze the sentiment of this text and respond with only: positive, negative, or neutral.\n\nText: ${text}`;
    return this.generate(prompt);
  }

  /**
   * Generate FAQ answers
   */
  async generateFAQAnswer(question, context = '') {
    const prompt = `Answer this FAQ question concisely (under 100 words):\n\nQuestion: ${question}\nContext: ${context}`;
    return this.generate(prompt);
  }

  /**
   * Get model info
   */
  async getModelInfo() {
    try {
      const response = await fetch(`${this.apiUrl.replace('/api', '')}/tags`);
      const data = await response.json();
      return data;
    } catch (error) {
      return { error: error.message };
    }
  }
}

// Export for use in browser and Node.js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = LlamaAI;
}
