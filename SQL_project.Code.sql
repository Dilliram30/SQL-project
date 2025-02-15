-- Task 1: Function to count employees/students
CREATE OR REPLACE FUNCTION count_entities(table_name VARCHAR2) RETURN NUMBER IS
    total_count NUMBER;
    stmt VARCHAR2(1000);
BEGIN
    stmt := 'SELECT COUNT(*) FROM ' || table_name;
    EXECUTE IMMEDIATE stmt INTO total_count;
    RETURN total_count;
END;
/
-- Task 2: Procedure for Simple Interest Calculation
CREATE OR REPLACE PROCEDURE calculate_simple_interest (
    p_principal IN NUMBER,
    p_rate IN NUMBER,
    p_months IN NUMBER,
    p_interest OUT NUMBER
) AS
BEGIN
    p_interest := (p_principal * p_rate * p_months) / (100 * 12);
END;
/
-- Task 3: Schema Creation & Accessing Tables from Another User
-- Run these commands as an admin user (e.g., SYSTEM)

-- Create a new user
CREATE USER new_user IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO new_user;

-- Switch to new_user and create tables/views
ALTER SESSION SET CURRENT_SCHEMA = new_user;

CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    name VARCHAR2(50)
);

CREATE VIEW student_view AS
SELECT student_id, name FROM students;

-- Switch back to old user and try to access the new_user's tables
ALTER SESSION SET CURRENT_SCHEMA = old_user;

SELECT * FROM new_user.students;
SELECT * FROM new_user.student_view;
-- Task 4: Joins using suppliers and orders tables

-- Create suppliers table
CREATE TABLE suppliers (
    supplier_id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
);

-- Create orders table
CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    supplier_id NUMBER,
    order_date DATE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Inner Join
SELECT s.name, o.order_date
FROM suppliers s
INNER JOIN orders o ON s.supplier_id = o.supplier_id;

-- Left Join
SELECT s.name, o.order_date
FROM suppliers s
LEFT JOIN orders o ON s.supplier_id = o.supplier_id;

-- Right Join
SELECT s.name, o.order_date
FROM suppliers s
RIGHT JOIN orders o ON s.supplier_id = o.supplier_id;

-- Full Outer Join
SELECT s.name, o.order_date
FROM suppliers s
FULL OUTER JOIN orders o ON s.supplier_id = o.supplier_id;
-- Task 5: Function to Extract Name from Combined Text
CREATE OR REPLACE FUNCTION extract_name(combined_text VARCHAR2) RETURN VARCHAR2 IS
    name_part VARCHAR2(100);
BEGIN
    name_part := SUBSTR(combined_text, 1, INSTR(combined_text, '_') - 1);
    RETURN name_part;
END;
/
-- Task 6: PL/SQL Block to Call Function & Procedure
DECLARE
    v_interest NUMBER;
    v_name VARCHAR2(100);
BEGIN
    -- Call simple interest procedure
    calculate_simple_interest(10000, 5, 6, v_interest);
    DBMS_OUTPUT.PUT_LINE('Simple Interest: ' || v_interest);
    
    -- Call name extraction function
    v_name := extract_name('krishna_krishna@gmail.com_12March2024_Pune');
    DBMS_OUTPUT.PUT_LINE('Extracted Name: ' || v_name);
END;
/
