
-- Handle boundary country
CREATE OR REPLACE FUNCTION boundary_country_init() RETURNS VOID AS
$$
DECLARE
    boundary_gen_table RECORD;
BEGIN
    FOR boundary_gen_table IN SELECT tablename
                              FROM pg_tables
                              WHERE schemaname = 'public' AND tablename LIKE 'osm_boundary_linestring_gen_%'
        LOOP
            EXECUTE 'ALTER TABLE ' || quote_ident(boundary_gen_table.tablename) || ' ADD COLUMN IF NOT EXISTS country VARCHAR[];';
            EXECUTE 'CREATE INDEX IF NOT EXISTS ' || quote_ident(boundary_gen_table.tablename) || '_country_idx ON ' || quote_ident(boundary_gen_table.tablename) || '(country);';
        END LOOP;
END
$$ LANGUAGE plpgsql;
SELECT boundary_country_init();

CREATE OR REPLACE FUNCTION boundary_country() RETURNS VOID AS
$$
DECLARE
    boundary_gen_table RECORD;
    country_code       RECORD;
BEGIN
    FOR boundary_gen_table IN SELECT tablename
                              FROM pg_tables
                              WHERE schemaname = 'public' AND tablename LIKE 'osm_boundary_linestring_gen_%'
        LOOP
            EXECUTE 'UPDATE ' || quote_ident(boundary_gen_table.tablename) || ' SET country = NULL;';
        END LOOP;

    FOR country_code IN SELECT osm_id, iso3166_1_alpha2 code
                        FROM osm_boundary_relation
                        WHERE admin_level = 2 AND iso3166_1_alpha2 IS NOT NULL
        LOOP
            FOR boundary_gen_table IN SELECT tablename
                                      FROM pg_tables
                                      WHERE schemaname = 'public' AND tablename LIKE 'osm_boundary_linestring_gen_%'
                LOOP
                    EXECUTE 'UPDATE ' || quote_ident(boundary_gen_table.tablename) ||
                            E' SET country = ARRAY_APPEND(country, \'' || country_code.code ||
                            E'\') WHERE osm_id IN (SELECT -member FROM osm_boundary_relation_member WHERE osm_id = ' ||
                            country_code.osm_id::text || ' AND type = 1)';
                END LOOP;
        END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT boundary_country();


-- etldoc: osm_boundary_linestring_gen13 -> boundary_z0
CREATE OR REPLACE VIEW boundary_z0 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen13
    WHERE admin_level = 2 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen7
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen12 -> boundary_z1
CREATE OR REPLACE VIEW boundary_z1 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen12
    WHERE admin_level <= 4 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen7
    WHERE admin_level = 2
);


-- etldoc: osm_boundary_linestring_gen11 -> boundary_z3
CREATE OR REPLACE VIEW boundary_z3 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen11
    WHERE admin_level <= 4 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen6
    WHERE admin_level = 2
);


-- etldoc: osm_boundary_linestring_gen10 -> boundary_z4
CREATE OR REPLACE VIEW boundary_z4 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen10
    WHERE admin_level <= 4 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen5
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen9 -> boundary_z5
CREATE OR REPLACE VIEW boundary_z5 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen9
    WHERE admin_level <= 4 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen4
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen8 -> boundary_z6
CREATE OR REPLACE VIEW boundary_z6 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen8
    WHERE admin_level <= 4 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen3
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen7 -> boundary_z7
CREATE OR REPLACE VIEW boundary_z7 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen7
    WHERE admin_level <= 4 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen2
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen6 -> boundary_z8
CREATE OR REPLACE VIEW boundary_z8 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen6
    WHERE admin_level <= 4 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring_gen1
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen5 -> boundary_z9
CREATE OR REPLACE VIEW boundary_z9 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen5
    WHERE admin_level <= 6 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen4 -> boundary_z10
CREATE OR REPLACE VIEW boundary_z10 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen4
    WHERE admin_level <= 6 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen3 -> boundary_z11
CREATE OR REPLACE VIEW boundary_z11 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen3
    WHERE admin_level <= 8 AND (array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country)))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen2 -> boundary_z12
CREATE OR REPLACE VIEW boundary_z12 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen2
    WHERE array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring
    WHERE admin_level = 2
);

-- etldoc: osm_boundary_linestring_gen1 -> boundary_z13
CREATE OR REPLACE VIEW boundary_z13 AS (
    SELECT geometry, admin_level, disputed, maritime
    FROM osm_boundary_linestring_gen1
    WHERE array_length(country, 1) IS NULL OR NOT ('CN' = ANY(country) OR 'TW' = ANY(country))
    UNION ALL
    SELECT geometry, admin_level, disputed, maritime
    FROM china_boundary_linestring
    WHERE admin_level = 2
);

-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1_2> z1_2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]

CREATE OR REPLACE FUNCTION layer_boundary (bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, admin_level int, disputed int, maritime int) AS $$
    SELECT geometry, admin_level, disputed::int, maritime::int FROM (
        -- etldoc: boundary_z0 ->  layer_boundary:z0
        SELECT * FROM boundary_z0 WHERE geometry && bbox AND zoom_level = 0
        UNION ALL
        -- etldoc: boundary_z1 ->  layer_boundary:z1_2
        SELECT * FROM boundary_z1 WHERE geometry && bbox AND zoom_level BETWEEN 1 AND 2
        UNION ALL
        -- etldoc: boundary_z3 ->  layer_boundary:z3
        SELECT * FROM boundary_z3 WHERE geometry && bbox AND zoom_level = 3
        UNION ALL
        -- etldoc: boundary_z4 ->  layer_boundary:z4
        SELECT * FROM boundary_z4 WHERE geometry && bbox AND zoom_level = 4
        UNION ALL
        -- etldoc: boundary_z5 ->  layer_boundary:z5
        SELECT * FROM boundary_z5 WHERE geometry && bbox AND zoom_level = 5
        UNION ALL
        -- etldoc: boundary_z6 ->  layer_boundary:z6
        SELECT * FROM boundary_z6 WHERE geometry && bbox AND zoom_level = 6
        UNION ALL
        -- etldoc: boundary_z7 ->  layer_boundary:z7
        SELECT * FROM boundary_z7 WHERE geometry && bbox AND zoom_level = 7
        UNION ALL
        -- etldoc: boundary_z8 ->  layer_boundary:z8
        SELECT * FROM boundary_z8 WHERE geometry && bbox AND zoom_level = 8
        UNION ALL
        -- etldoc: boundary_z9 ->  layer_boundary:z9
        SELECT * FROM boundary_z9 WHERE geometry && bbox AND zoom_level = 9
        UNION ALL
        -- etldoc: boundary_z10 ->  layer_boundary:z10
        SELECT * FROM boundary_z10 WHERE geometry && bbox AND zoom_level = 10
        UNION ALL
        -- etldoc: boundary_z11 ->  layer_boundary:z11
        SELECT * FROM boundary_z11 WHERE geometry && bbox AND zoom_level = 11
        UNION ALL
        -- etldoc: boundary_z12 ->  layer_boundary:z12
        SELECT * FROM boundary_z12 WHERE geometry && bbox AND zoom_level = 12
        UNION ALL
        -- etldoc: boundary_z13 -> layer_boundary:z13
        SELECT * FROM boundary_z13 WHERE geometry && bbox AND zoom_level >= 13
    ) AS zoom_levels;
$$ LANGUAGE SQL IMMUTABLE;


-- Handle updates

CREATE SCHEMA IF NOT EXISTS boundary;

CREATE TABLE IF NOT EXISTS boundary.updates(id serial primary key, t text, unique (t));
CREATE OR REPLACE FUNCTION boundary.flag() RETURNS trigger AS $$
BEGIN
    INSERT INTO boundary.updates(t) VALUES ('y')  ON CONFLICT(t) DO NOTHING;
    RETURN null;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION boundary.refresh() RETURNS trigger AS $$
BEGIN
    RAISE LOG 'Refresh boundary';
    PERFORM boundary_country();
    DELETE FROM boundary.updates;
    RETURN null;
END;
$$ language plpgsql;

DROP TRIGGER IF EXISTS trigger_flag ON osm_boundary_linestring;
CREATE TRIGGER trigger_flag
    AFTER INSERT OR UPDATE ON osm_boundary_linestring
    FOR EACH STATEMENT
    EXECUTE PROCEDURE boundary.flag();

DROP TRIGGER IF EXISTS trigger_flag ON osm_boundary_relation;
CREATE TRIGGER trigger_flag
    AFTER INSERT OR UPDATE OR DELETE ON osm_boundary_relation
    FOR EACH STATEMENT
    EXECUTE PROCEDURE boundary.flag();

DROP TRIGGER IF EXISTS trigger_refresh ON boundary.updates;
CREATE CONSTRAINT TRIGGER trigger_refresh
    AFTER INSERT ON boundary.updates
    INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE PROCEDURE boundary.refresh();