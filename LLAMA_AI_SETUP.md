# Gumroad Creator Hub - Llama AI Setup Guide

## Overview

This guide explains how to set up **TinyLlama** (1.1B parameter model) with **Ollama** for local, on-device AI capabilities. TinyLlama is the lightest-weight Llama model optimized for phones and low-resource devices.

---

## Why TinyLlama?

| Aspect | Details |
| :--- | :--- |
| **Size** | ~600MB (fits on any phone) |
| **Memory** | ~2GB RAM required (minimal) |
| **Speed** | Fast inference on mobile devices |
| **Quality** | Good for product descriptions, suggestions, sentiment analysis |
| **Cost** | Completely free, runs locally |
| **Privacy** | All processing happens on your device |

---

## Part 1: Desktop/Laptop Setup

### Step 1: Install Ollama

Download and install Ollama from [https://ollama.ai](https://ollama.ai) for your operating system (macOS, Windows, or Linux).

### Step 2: Pull TinyLlama Model

Open your terminal and run:
```bash
ollama pull tinyllama
```

This downloads the TinyLlama model (~600MB). First-time download may take 5-10 minutes depending on your internet speed.

### Step 3: Start Ollama Service

Run the Ollama server:
```bash
ollama serve
```

The service will start on `http://localhost:11434` by default. You should see output like:
```
2024/01/15 10:30:45 "GET /api/tags HTTP/1.1" 200 123
```

### Step 4: Access AI Assistant

1. Open your browser and navigate to the **AI Assistant** page
2. The status indicator should show **✓ Llama AI is online**
3. Start using the AI tools!

---

## Part 2: Termux (Android Phone) Setup

### Step 1: Install Termux

Download **Termux** from [F-Droid](https://f-droid.org/packages/com.termux/) (recommended) or GitHub. The Google Play Store version is deprecated.

### Step 2: Grant Storage Permission

```bash
termux-setup-storage
```

### Step 3: Install Dependencies

```bash
pkg update && pkg upgrade -y
pkg install -y git curl wget
```

### Step 4: Install Ollama in Termux

```bash
# Method 1: Using package manager (if available)
pkg install -y ollama

# Method 2: Manual installation (if not available)
# Visit https://github.com/ollama/ollama for latest instructions
```

### Step 5: Pull TinyLlama

```bash
ollama pull tinyllama
```

**Note**: First pull may take 10-20 minutes on a phone. Ensure stable Wi-Fi connection.

### Step 6: Start Ollama on Your Phone

```bash
# Make it accessible from other devices on your network
ollama serve --host 0.0.0.0
```

You should see:
```
Listening on 127.0.0.1:11434
```

### Step 7: Access from Browser

Open your phone's browser and go to:
```
http://localhost:11434
```

Or from another device on the same Wi-Fi:
```
http://<YOUR_PHONE_IP>:11434
```

Find your phone's IP by running:
```bash
ifconfig
```

---

## Part 3: Using the AI Assistant

### Available Tools

| Tool | Use Case | Example |
| :--- | :--- | :--- |
| **Product Description Generator** | Create compelling product descriptions | Input: "Digital Marketing Course" → Output: SEO-optimized description |
| **Product Title Generator** | Generate catchy product titles | Input: Product description → Output: 3 title variations |
| **Text Enhancer** | Improve clarity and engagement | Input: Your text → Output: Enhanced version |
| **Writing Suggestions** | Get AI feedback on your writing | Input: Your text → Output: One improvement suggestion |
| **FAQ Answer Generator** | Create customer support answers | Input: Question + context → Output: Professional answer |
| **Sentiment Analysis** | Analyze customer feedback | Input: Review text → Output: Positive/Negative/Neutral |

### Example Workflow

1. **Create a new product** in the Admin Panel
2. **Go to AI Assistant** → Product Tools
3. **Enter product name and category** → Click "Generate Description"
4. **Copy the generated description** to your product
5. **Generate titles** for better SEO
6. **Save your product**

---

## Part 4: Configuration & Optimization

### Adjust Settings for Phone Performance

In the **AI Assistant Settings** tab:

- **Temperature**: Set to 0.5-0.7 for more focused responses (faster)
- **Max Tokens**: Set to 128-256 for shorter responses (less memory usage)
- **Model**: Stick with `tinyllama` for best phone performance

### Reduce Response Time

```bash
# On Termux, limit concurrent requests
ollama serve --host 0.0.0.0 --num-gpu 0  # Use CPU only (more stable on phones)
```

### Monitor Phone Resources

While running Ollama, you can check resource usage:
```bash
# In Termux
top
```

TinyLlama typically uses:
- **CPU**: 20-40%
- **RAM**: 1.5-2GB
- **Storage**: ~600MB for model

---

## Part 5: Troubleshooting

### "Llama AI service not available"

**Solution**: Ensure Ollama is running:
```bash
# Desktop
ollama serve

# Termux
ollama serve --host 0.0.0.0
```

### Model Takes Too Long to Download

**Solution**: Use a stable Wi-Fi connection. The 600MB download can take 5-20 minutes depending on speed.

### Phone Gets Hot or Battery Drains Quickly

**Solution**: 
- Reduce `max_tokens` to 128
- Set `temperature` to 0.5
- Close other apps
- Use CPU-only mode: `ollama serve --num-gpu 0`

### "Connection refused" Error

**Solution**: Check if Ollama is running on the correct port:
```bash
# Default port is 11434
# If using a different port, update settings in AI Assistant
```

### Model Crashes or Stops Responding

**Solution**: Restart Ollama:
```bash
# Press Ctrl+C to stop
# Then run again
ollama serve --host 0.0.0.0
```

---

## Part 6: Advanced Usage

### Using Ollama with External APIs

If you want to integrate with your backend:

```javascript
// Example: Call Ollama from your Node.js server
const response = await fetch('http://localhost:11434/api/generate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model: 'tinyllama',
    prompt: 'Generate a product description for a digital course',
    stream: false
  })
});
const data = await response.json();
console.log(data.response);
```

### Alternative Models

If you want to try other lightweight models:

```bash
# Phi (2.7B) - Slightly larger but faster
ollama pull phi

# Neural Chat (7B) - Better quality but needs more resources
ollama pull neural-chat
```

**Recommendation**: Stick with `tinyllama` for phones. Larger models require 4GB+ RAM.

---

## Part 7: Integration with Gumroad Creator Hub

### Automatic Integration

The AI Assistant is already integrated with:
- **Admin Panel**: Access via link in sidebar
- **Product Creation**: Use AI to generate descriptions
- **Content Tools**: Enhance your ebook content
- **Analytics**: Analyze customer sentiment

### Manual Integration

To add AI features to other parts of the app:

```html
<!-- Include the Llama AI library -->
<script src="llama-ai.js"></script>

<!-- Use in your code -->
<script>
  const llama = new LlamaAI({ apiUrl: 'http://localhost:11434/api' });
  
  // Generate description
  const description = await llama.generateProductDescription('My Product', 'Digital');
  console.log(description);
</script>
```

---

## Summary

| Platform | Setup Time | Resource Usage | Recommendation |
| :--- | :--- | :--- | :--- |
| **Desktop** | 5-10 min | Low | Best for development |
| **Termux Phone** | 20-30 min | Medium | Great for on-the-go |
| **Both** | 30-40 min | Medium | Optimal flexibility |

**Start with desktop first**, then move to Termux once you're comfortable with the workflow.

Happy creating! 🚀
