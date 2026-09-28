package com.shop.order;

import com.shop.product.Product;
import com.shop.product.ProductRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

/**
 * Business logic for order management.
 */
@Service
@Transactional(readOnly = true)
public class OrderService {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;

    public OrderService(OrderRepository orderRepository,
                        ProductRepository productRepository) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
    }

    public List<Order> findAll() {
        return orderRepository.findAll();
    }

    public Optional<Order> findById(Long id) {
        return orderRepository.findById(id);
    }

    @Transactional
    public Order createOrder(OrderRequest request) {
        Order order = new Order();
        order.setCustomerName(request.getCustomerName());
        order.setCustomerEmail(request.getCustomerEmail());
        order.setTotalAmount(request.getTotalAmount());
        order.setStatus(Order.Status.PENDING);

        if (request.getItems() != null) {
            for (OrderRequest.ItemDto dto : request.getItems()) {
                Product product = productRepository.findById(dto.getProductId())
                        .orElseThrow(() -> new ResponseStatusException(
                                HttpStatus.BAD_REQUEST,
                                "Product not found: " + dto.getProductId()));

                OrderItem item = new OrderItem(order, product,
                        dto.getQuantity(), dto.getUnitPrice());
                order.addItem(item);
            }
        }

        return orderRepository.save(order);
    }
}
