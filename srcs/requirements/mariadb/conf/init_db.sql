-- Configure root user to use password authentication
UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;

-- Create the database
CREATE DATABASE IF NOT EXISTS `${MYSQL_DATABASE}`;

-- Create a user and grant privileges
CREATE USER IF NOT EXISTS `${MYSQL_USER}`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON `${MYSQL_DATABASE}`.* TO `${MYSQL_USER}`@'%';
FLUSH PRIVILEGES;
