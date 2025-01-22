# 🌟 ClarityMarket: Decentralized Digital Marketplace

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Clarity Version](https://img.shields.io/badge/Clarity-2.0-blue)](https://clarity-lang.org/)
[![Network](https://img.shields.io/badge/Network-Stacks-purple)](https://www.stacks.co/)

A streamlined, secure, and efficient decentralized marketplace smart contract built with Clarity for the Stacks blockchain. ClarityMarket enables seamless listing, trading, and management of digital assets with automated fee processing and ownership tracking.

## 📑 Table of Contents

- [Features](#features)
- [Technical Architecture](#technical-architecture)
- [Function Reference](#function-reference)
- [Getting Started](#getting-started)
- [Usage Examples](#usage-examples)
- [Security Considerations](#security-considerations)
- [Fee Structure](#fee-structure)
- [Testing](#testing)
- [Contributing](#contributing)

## ✨ Features

- **Streamlined Listing Management**: Create, update, and cancel listings with ease
- **Secure Transactions**: Built-in ownership verification and state management
- **Automated Fee Processing**: Transparent 2.5% platform fee handling
- **Market Analytics**: Built-in volume tracking
- **Ownership Tracking**: Comprehensive tracking of item ownership
- **Error Handling**: Robust error checking and reporting

## 🏗 Technical Architecture

### Constants
```clarity
contract-owner: Principal of contract deployer
fee-rate: u25 (2.5% represented in basis points)
```

### Data Structures

#### Items Map
```clarity
{
    item-id: uint,
    owner: principal,
    price: uint,
    description: string-ascii,
    is-sold: bool
}
```

### State Variables
- `next-item-id`: Autoincrementing counter for item IDs
- `market-volume`: Tracks total trading volume

## 🔧 Function Reference

### Read-Only Functions

#### `get-item`
```clarity
(define-read-only (get-item (item-id uint)))
```
Returns item details for given ID.

#### `get-market-volume`
```clarity
(define-read-only (get-market-volume))
```
Returns total trading volume.

### Public Functions

#### `list-item`
```clarity
(define-public (list-item (price uint) (description (string-ascii 50))))
```
**Parameters:**
- `price`: Listed price in microSTX
- `description`: Item description (max 50 characters)

**Returns:** `ok` with item ID or `err` on failure

#### `update-price`
```clarity
(define-public (update-price (item-id uint) (new-price uint)))
```
**Parameters:**
- `item-id`: ID of listed item
- `new-price`: Updated price in microSTX

#### `cancel-listing`
```clarity
(define-public (cancel-listing (item-id uint)))
```
**Parameters:**
- `item-id`: ID of listed item to cancel

#### `buy-item`
```clarity
(define-public (buy-item (item-id uint)))
```
**Parameters:**
- `item-id`: ID of item to purchase

## 🚀 Getting Started

### Prerequisites
- Clarity CLI tools
- Stacks wallet
- Test STX tokens for testnet deployment

### Deployment Steps
1. Clone this repository
2. Configure deployment settings
3. Deploy using Clarity CLI:
```bash
clarity deploy marketplace.clar
```

## 💡 Usage Examples

### Listing an Item
```clarity
(contract-call? .marketplace list-item u1000000 "Rare Digital Collectible")
```

### Purchasing an Item
```clarity
(contract-call? .marketplace buy-item u1)
```

## 🔐 Security Considerations

1. **Ownership Verification**
   - All modifications require owner authentication
   - Prevents unauthorized listing changes

2. **State Management**
   - Strict checking of item status
   - Prevention of double-sales
   - Atomic transactions

3. **Error Handling**
   - Comprehensive error codes
   - Clear error messages
   - Transaction rollback on failure

## 💰 Fee Structure

- Platform fee: 2.5% (25 basis points)
- Fee calculation: `fee = price * fee-rate / 1000`
- Fees are automatically processed during purchase
- Fees are sent to contract owner

## 🧪 Testing

Run the test suite:
```bash
clarity test marketplace_test.clar
```

### Test Coverage
- Listing creation
- Price updates
- Purchase flow
- Error conditions
- Fee calculations

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📞 Contact

For questions and support, please open an issue in the repository or contact the maintainers.

---
*Built with ❤️ for the Stacks ecosystem*
