// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Exchange {
    
    // Define variables
    address payable public owner;
    uint public orderCount = 0;
    mapping(uint => Order) public orders;
    mapping(address => uint) public balances;
    
    // Define struct for order
    struct Order {
        uint id;
        address payable seller;
        address payable buyer;
        uint price;
        bool completed;
    }
    
    // Define events for when an order is created and when an order is completed
    event OrderCreated(uint id, address payable seller, address payable buyer, uint price, bool completed);
    event OrderCompleted(uint id, address payable seller, address payable buyer, uint price, bool completed);
    
    // Constructor function
    constructor() {
        owner = payable(msg.sender);
    }
    
    // Sell function - create a new order
    function sell(uint _price) public {
        // Increment order count
        orderCount++;
        
        // Create new order
        orders[orderCount] = Order(orderCount, payable(msg.sender), payable(address(0)), _price, false);
        
        // Emit event
        emit OrderCreated(orderCount, payable(msg.sender), payable(address(0)), _price, false);
    }
    
    // Buy function - complete an existing order
    function buy(uint _id) public payable {
        // Get order from mapping
        Order memory _order = orders[_id];
        
        // Make sure order exists and is not completed
        require(_order.id > 0 && _order.completed == false, "Order does not exist or is already completed.");
        
        // Make sure buyer has enough ether to purchase order
        require(msg.value >= _order.price, "Not enough ether sent to purchase order.");
        
        // Transfer ether to seller
        _order.seller.transfer(msg.value);
        
        // Update order to completed
        _order.buyer = payable(msg.sender);
        _order.completed = true;
        orders[_id] = _order;
        
        // Emit event
        emit OrderCompleted(_id, _order.seller, payable(msg.sender), _order.price, true);
    }
    
    // Deposit function - add ether to user's balance
    function deposit() public payable {
        // Add ether to user's balance
        balances[msg.sender] += msg.value;
    }
    
    // Withdraw function - withdraw ether from user's balance
    function withdraw(uint _amount) public {
        // Make sure user has enough ether in their balance
        require(balances[msg.sender] >= _amount, "Not enough ether in balance to withdraw.");
        
        // Subtract ether from user's balance and transfer to user
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
    
    // Order function - get order details
    function getOrder(uint _id) public view returns (uint, address, address, uint, bool) {
        // Get order from mapping and return details
        Order memory _order = orders[_id];
        return (_order.id, _order.seller, _order.buyer, _order.price, _order.completed);
    }
}
