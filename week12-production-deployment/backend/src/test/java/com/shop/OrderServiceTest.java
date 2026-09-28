package com.shop;

import com.shop.order.Order;
import com.shop.order.OrderRepository;
import com.shop.order.OrderRequest;
import com.shop.order.OrderService;
import com.shop.product.ProductRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrderService unit tests")
class OrderServiceTest {

    @Mock
    private OrderRepository orderRepository;

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private OrderService orderService;

    @Test
    @DisplayName("findAll returns all orders from repository")
    void findAll_returnsOrders() {
        Order order = new Order();
        order.setCustomerName("Alice");
        order.setCustomerEmail("alice@example.com");
        order.setTotalAmount(BigDecimal.TEN);

        when(orderRepository.findAll()).thenReturn(List.of(order));

        List<Order> result = orderService.findAll();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getCustomerName()).isEqualTo("Alice");
    }

    @Test
    @DisplayName("createOrder with no items saves the order")
    void createOrder_withNoItems_savesOrder() {
        OrderRequest request = new OrderRequest();
        request.setCustomerName("Bob");
        request.setCustomerEmail("bob@example.com");
        request.setTotalAmount(new BigDecimal("50.00"));
        request.setItems(Collections.emptyList());

        Order savedOrder = new Order();
        savedOrder.setCustomerName("Bob");
        savedOrder.setCustomerEmail("bob@example.com");
        savedOrder.setTotalAmount(new BigDecimal("50.00"));
        savedOrder.setStatus(Order.Status.PENDING);

        when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);

        Order result = orderService.createOrder(request);

        assertThat(result.getCustomerName()).isEqualTo("Bob");
        assertThat(result.getStatus()).isEqualTo(Order.Status.PENDING);
        verify(orderRepository).save(any(Order.class));
    }
}
