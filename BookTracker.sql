DROP TABLE books
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    birth_date DATE
);

INSERT INTO authors (name, birth_date) VALUES
('George Orwell', '1903-06-25'),
('Harper Lee', '1926-04-28'),
('F. Scott Fitzgerald', '1896-09-24'),
('J.K. Rowling', '1965-07-31'),
('Ernest Hemingway', '1899-07-21'),
('Jane Austen', '1775-12-16'),
('Mark Twain', '1835-11-30'),
('J.R.R. Tolkien', '1892-01-03'),
('Agatha Christie', '1890-09-15'),
('Isaac Asimov', '1920-01-02');

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INTEGER REFERENCES authors(id),
    published_date DATE
);

INSERT INTO books (title, author_id, published_date) VALUES
('1984', 1, '1949-06-08'),
('To Kill a Mockingbird', 2, '1960-07-11'),
('The Great Gatsby', 3, '1925-04-10'),
('Harry Potter and the Philosopher\s Stone', 4, '1997-06-26'),
('The Old Man and the Sea', 5, '1952-09-01'),
('Pride and Prejudice', 6, '1813-01-28'),
('Adventures of Huckleberry Finn', 7, '1884-02-18'),
('The Hobbit', 8, '1937-09-21'),
('Murder on the Orient Express', 9, '1934-01-01'),
('Foundation', 10, '1951-06-01');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

INSERT INTO users (username, email) VALUES
('alice', 'alice@example.com'),
('bob', 'bob@example.com'),
('charlie', 'charlie@example.com'),
('david', 'david@example.com'),
('eve', 'eve@example.com'),
('frank', 'frank@example.com'),
('grace', 'grace@example.com'),
('hannah', 'hannah@example.com'),
('ivan', 'ivan@example.com'),
('judy', 'judy@example.com'),
('kate', 'kate@example.com'),
('leo', 'leo@example.com'),
('mike', 'mike@example.com'),
('nina', 'nina@example.com'),
('oliver', 'oliver@example.com');


CREATE TABLE loans (
    id SERIAL PRIMARY KEY,
    book_id INTEGER REFERENCES books(id),
    user_id INTEGER REFERENCES users(id),
    loan_date DATE NOT NULL,
    return_date DATE
);

INSERT INTO loans (book_id, user_id, loan_date, return_date) VALUES
(1, 1, '2024-01-01', '2024-01-15'),
(2, 2, '2024-01-05', '2024-01-20'),
(3, 3, '2024-01-10', NULL),
(4, 4, '2024-01-12', '2024-01-26'),
(5, 5, '2024-01-15', NULL),
(6, 6, '2024-01-20', '2024-02-03'),
(7, 7, '2024-01-25', NULL),
(8, 8, '2024-01-28', '2024-02-10'),
(9, 9, '2024-02-01', NULL),
(10, 10, '2024-02-05', '2024-02-19'),
(1, 11, '2024-02-10', '2024-02-24'),
(2, 12, '2024-02-12', '2024-02-26'),
(3, 13, '2024-02-15', NULL),
(4, 14, '2024-02-20', '2024-03-05'),
(5, 15, '2024-02-25', NULL),
(6, 1, '2024-03-01', NULL),
(7, 2, '2024-03-05', '2024-03-15'),
(8, 3, '2024-03-10', NULL),
(9, 4, '2024-03-15', '2024-03-25'),
(10, 5, '2024-03-20', NULL);

SELECT * FROM authors;
SELECT * FROM books;
SELECT * FROM loans;

--3. İlişkilendirme ve Daha Karmaşık Sorgular
--Tablolar arası ilişkileri kullanarak daha karmaşık sorgular oluşturabilirsin. Örneğin, hangi yazarın hangi kitapları yazdığını görebilirsin:

SELECT a.name AS author_name, b.title AS book_title
FROM authors a
JOIN books b ON a.id = b.author_id;

--4. Veri Güncelleme ve Silme
--Veritabanındaki verileri güncelleme veya silme işlemleri yapabilirsin. Örneğin, bir yazarın bilgilerini güncellemek:
select * from authors
UPDATE authors
SET birth_date = '1903-06-25'
WHERE name = 'George Orwell';

/*5. Test Senaryoları Oluştur
Projenin amacına uygun test senaryoları oluşturabilirsin. Örneğin:

Bir kullanıcının hangi kitapları ödünç aldığını sorgulama.
Hangi yazarların en fazla kitabı olduğunu belirleme.
Ödünç alınan kitapların iade tarihlerinin kontrolü.*/

SELECT b.title AS book_title, l.loan_date, l.return_date
FROM loans l
JOIN books b ON l.book_id = b.id
WHERE l.user_id = 1;


/*Hangi yazarların en fazla kitabı olduğunu belirleme.
Ödünç alınan kitapların iade tarihlerinin kontrolü.
6. Raporlama ve Analiz
Veritabanındaki verileri kullanarak raporlar veya analizler oluşturabilirsin. Örneğin:

Hangi yazarın en çok kitabı var?
En fazla ödünç alınan kitap hangisi?*/

SELECT a.name AS author_name, COUNT(b.id) AS book_count
FROM authors a
LEFT JOIN books b ON a.id = b.author_id
GROUP BY a.id
ORDER BY book_count DESC;

--Ödünç alınan kitapların iade tarihlerinin kontrolü.
--İade Edilmemiş Kitapları Kontrol Etme
SELECT b.title AS book_title, l.loan_date, l.return_date
FROM loans l
JOIN books b ON l.book_id = b.id
WHERE l.return_date IS NULL;  -- İade edilmemiş kitaplar için

--Geçmişte İade Edilmesi Gereken Kitapları Kontrol Etme

SELECT b.title AS book_title, l.loan_date, l.return_date
FROM loans l
JOIN books b ON l.book_id = b.id
WHERE l.return_date < CURRENT_DATE;  -- İade tarihi geçmiş kitaplar

--En Fazla Ödünç Alınan Kitaplar

SELECT b.title AS book_title, COUNT(l.id) AS loan_count
FROM books b
JOIN loans l ON b.id = l.book_id
GROUP BY b.id
ORDER BY loan_count DESC;

-- En Aktif Kullanıcılar

SELECT l.user_id, COUNT(l.id) AS loan_count
FROM loans l
GROUP BY l.user_id
ORDER BY loan_count DESC;

-- Kitapların İade Durumu

SELECT 
    COUNT(CASE WHEN l.return_date IS NULL THEN 1 END) AS not_returned,
    COUNT(CASE WHEN l.return_date IS NOT NULL THEN 1 END) AS returned
FROM loans l;

-- Her Yazar İçin Kitap Sayısı ve İade Durumu

SELECT a.name AS author_name, 
       COUNT(b.id) AS total_books,
       COUNT(CASE WHEN l.return_date IS NULL THEN 1 END) AS not_returned
FROM authors a
LEFT JOIN books b ON a.id = b.author_id
LEFT JOIN loans l ON b.id = l.book_id
GROUP BY a.id;

-- Ödünç Alma ve İade Trendleri

SELECT DATE(l.loan_date) AS date, COUNT(l.id) AS loan_count
FROM loans l
WHERE l.loan_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(l.loan_date)
ORDER BY date;
