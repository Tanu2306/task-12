package com.shop;

import com.shop.product.Product;
import com.shop.product.ProductRepository;
import com.shop.product.ProductService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProductService unit tests")
class ProductServiceTest {

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private ProductService productService;

    private Product sampleProduct;

    @BeforeEach
    void setUp() {
        sampleProduct = new Product(
                "Test Widget",
                "A test product",
                new BigDecimal("19.99"),
                "Test",
                10
        );
        // Simulate JPA assigning an ID
        sampleProduct.setId(1L);
    }

    @Test
    @DisplayName("findAll returns all products from repository")
    void findAll_returnsAllProducts() {
        when(productRepository.findAll()).thenReturn(List.of(sampleProduct));

        List<Product> result = productService.findAll();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).isEqualTo("Test Widget");
        verify(productRepository, times(1)).findAll();
    }

    @Test
    @DisplayName("findById returns product when it exists")
    void findById_returnsProduct_whenExists() {
        when(productRepository.findById(1L)).thenReturn(Optional.of(sampleProduct));

        Optional<Product> result = productService.findById(1L);

        assertThat(result).isPresent();
        assertThat(result.get().getPrice()).isEqualByComparingTo("19.99");
    }

    @Test
    @DisplayName("findById returns empty when product does not exist")
    void findById_returnsEmpty_whenNotFound() {
        when(productRepository.findById(99L)).thenReturn(Optional.empty());

        Optional<Product> result = productService.findById(99L);

        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("save delegates to repository and returns saved entity")
    void save_delegatesToRepository() {
        when(productRepository.save(sampleProduct)).thenReturn(sampleProduct);

        Product saved = productService.save(sampleProduct);

        assertThat(saved).isNotNull();
        assertThat(saved.getId()).isEqualTo(1L);
        verify(productRepository).save(sampleProduct);
    }

    @Test
    @DisplayName("findInStock delegates to repository with minStock=0")
    void findInStock_delegatesToRepository() {
        when(productRepository.findByStockQuantityGreaterThan(0))
                .thenReturn(List.of(sampleProduct));

        List<Product> result = productService.findInStock();

        assertThat(result).hasSize(1);
        verify(productRepository).findByStockQuantityGreaterThan(0);
    }
}
