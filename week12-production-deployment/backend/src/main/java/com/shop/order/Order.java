package com.shop.order;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * JPA entity mapping to the "orders" table.
 */
@Entity
@Table(name = "orders")
public class Order {

    public enum Status { PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(name = "customer_name", nullable = false, length = 200)
    private String customerName;

    @Email
    @Column(name = "customer_email", nullable = false, length = 200)
    private String customerEmail;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Status status = Status.PENDING;

    @Column(name = "total_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    // ── Lifecycle ────────────────────────────────────────────────────────
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // ── Helpers ──────────────────────────────────────────────────────────
    public void addItem(OrderItem item) {
        items.add(item);
        item.setOrder(this);
    }

    // ── Constructors ─────────────────────────────────────────────────────
    public Order() {}

    // ── Getters & Setters ─────────────────────────────────────────────────
    public Long getId()                              { return id; }
    public String getCustomerName()                  { return customerName; }
    public void setCustomerName(String n)            { this.customerName = n; }
    public String getCustomerEmail()                 { return customerEmail; }
    public void setCustomerEmail(String e)           { this.customerEmail = e; }
    public Status getStatus()                        { return status; }
    public void setStatus(Status status)             { this.status = status; }
    public BigDecimal getTotalAmount()               { return totalAmount; }
    public void setTotalAmount(BigDecimal ta)        { this.totalAmount = ta; }
    public LocalDateTime getCreatedAt()              { return createdAt; }
    public List<OrderItem> getItems()               { return items; }
}
