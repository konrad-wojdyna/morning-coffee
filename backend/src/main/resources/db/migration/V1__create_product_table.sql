

CREATE TABLE product (
                         id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                         name             VARCHAR(120) NOT NULL,
                         slug             VARCHAR(140) NOT NULL,
                         description      TEXT,
                         origin_country   VARCHAR(60)  NOT NULL,
                         farm             VARCHAR(80),
                         process          VARCHAR(30)  NOT NULL,
                         altitude_masl    INT,
                         cupping_score    NUMERIC(4,1),
                         roast_level      SMALLINT     NOT NULL,
                         flavour_notes    VARCHAR(200),
                         roasted_on       DATE         NOT NULL,
                         discontinued_at  TIMESTAMPTZ,
                         created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
                         updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),

                         CONSTRAINT uq_product_slug UNIQUE (slug),
                         CONSTRAINT ck_product_roast_level CHECK (roast_level BETWEEN 1 AND 3),
                         CONSTRAINT ck_product_altitude CHECK (altitude_masl IS NULL OR altitude_masl > 0),
                         CONSTRAINT ck_product_cupping_score CHECK (cupping_score IS NULL OR cupping_score BETWEEN 0 AND 100)
);

CREATE TABLE product_variant (
                                 id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                 product_id       BIGINT       NOT NULL,
                                 grind            VARCHAR(20)  NOT NULL,
                                 weight_grams     INT          NOT NULL,
                                 price_gross      INT          NOT NULL,
                                 stock_quantity   INT          NOT NULL DEFAULT 0,
                                 active           BOOLEAN      NOT NULL DEFAULT TRUE,
                                 created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
                                 updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),

                                 CONSTRAINT fk_variant_product FOREIGN KEY (product_id)
                                     REFERENCES product (id),
                                 CONSTRAINT uq_variant_product_grind_weight UNIQUE (product_id, grind, weight_grams),
                                 CONSTRAINT ck_variant_price CHECK (price_gross > 0),
                                 CONSTRAINT ck_variant_stock CHECK (stock_quantity >= 0),
                                 CONSTRAINT ck_variant_weight CHECK (weight_grams > 0)
);

CREATE INDEX idx_variant_product ON product_variant (product_id);
CREATE INDEX idx_product_origin ON product (origin_country);