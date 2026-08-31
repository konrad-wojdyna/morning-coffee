package pl.morningcoffee.shop.product;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Entity
@Table(name = "product")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 120,  nullable = false)
    private String name;

    @Column(length = 140,  nullable = false)
    private String slug;

    @Column(columnDefinition = "text")
    private String description;

    @Column(name = "origin_country", length = 60,  nullable = false)
    private String originCountry;

    @Column(length = 80)
    private String farm;

    @Column(length = 30, nullable = false)
    private String process;

    @Column(name = "altitude_masl")
    private Integer altitudeMasl;

    @Column(name = "cupping_score", precision = 4, scale = 1)
    private BigDecimal cuppingScore;

    @Column(name = "roast_level", nullable = false)
    private Short roastLevel;

    @Column(name = "flavour_notes", length = 200)
    private String flavourNotes;

    @Column(name = "roasted_on", nullable = false)
    private LocalDate roastedOn;

    @Column(name = "discontinued_at")
    private Instant discontinuedAt;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;
}
