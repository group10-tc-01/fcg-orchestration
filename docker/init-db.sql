-- Initialize both databases for FCG applications
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'fcg_user')
BEGIN
    CREATE DATABASE fcg_user;
    PRINT 'Database fcg_user created successfully';
END
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'fcg_payment')
BEGIN
    CREATE DATABASE fcg_payment;
    PRINT 'Database fcg_payment created successfully';
END
GO
