package com.shop.product;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Business logic layer for Product operations.
 * Kept minimal for a student DevOps demo – focus is on infrastructure.
 */
@Service
@Transactional(readOnly = true)
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    /** Return all products. */
    public List<Product> findAll() {
        return productRepository.findAll();
    }

    /** Return a product by its primary key. */
    public Optional<Product> findById(Long id) {
        return productRepository.findById(id);
    }

    /** Persist a new product. */
    @Transactional
    public Product save(Product product) {
        return productRepository.save(product);
    }

    /** Return only products that have stock available. */
    public List<Product> findInStock() {
        return productRepository.findByStockQuantityGreaterThan(0);
    }
}
