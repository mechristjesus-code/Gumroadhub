# Gumroad Creator Hub

A professional, production-ready companion application for Gumroad creators.

## Overview
This application provides a comprehensive suite of tools for managing a digital storefront, creating content, and analyzing performance on-the-go.

## Key Features
- **Storefront Management**: CRUD operations for products with search/filter capabilities.
- **Performance Analytics**: Live-fetched insights with automated visualizations.
- **Content Creation**: Integrated **E-book Creator** powered by **WordGenie** AI (audio transcription, smart editing).
- **Security**: Secure authentication with `flutter_secure_storage` and groundwork for biometric (`local_auth`) support.
- **Offline Reliability**: Local caching using `Hive` for seamless performance.
- **Advanced Tools**: License key management and CSV data exportation.
- **Local AI (Experimental)**: Infrastructure for on-device LLM inference using `TinyLlama`.

## Setup
1. Clone the repository.
2. Run `flutter pub get`.
3. Ensure Android NDK is configured for FFI/native modules.
4. Run `flutter run`.
