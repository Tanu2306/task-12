package com.shop.order;

import java.math.BigDecimal;
import java.util.List;

/**
 * DTO for incoming order creation requests from the frontend.
 * Keeps entity classes clean from HTTP concerns.
 */
public class OrderRequest {

    private String customerName;
    private String customerEmail;
    private BigDecimal totalAmount;
    private List<ItemDto> items;

    // ── Nested DTO ────────────────────────────────────────────────────────
    public static class ItemDto {
        private Long productId;
        private Integer quantity;
        private BigDecimal unitPrice;

        public Long getProductId()             { return productId; }
        public void setProductId(Long pid)     { this.productId = pid; }
        public Integer getQuantity()           { return quantity; }
        public void setQuantity(Integer q)     { this.quantity = q; }
        public BigDecimal getUnitPrice()       { return unitPrice; }
        public void setUnitPrice(BigDecimal p) { this.unitPrice = p; }
    }

    // ── Getters & Setters ─────────────────────────────────────────────────
    public String getCustomerName()            { return customerName; }
    public void setCustomerName(String n)      { this.customerName = n; }
    public String getCustomerEmail()           { return customerEmail; }
    public void setCustomerEmail(String e)     { this.customerEmail = e; }
    public BigDecimal getTotalAmount()         { return totalAmount; }
    public void setTotalAmount(BigDecimal ta)  { this.totalAmount = ta; }
    public List<ItemDto> getItems()            { return items; }
    public void setItems(List<ItemDto> items)  { this.items = items; }
}
