package com.shop.product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    /** Find products by category (case-insensitive). */
    List<Product> findByCategoryIgnoreCase(String category);

    /** Find products with stock > 0 (in-stock only). */
    List<Product> findByStockQuantityGreaterThan(int minStock);
}
