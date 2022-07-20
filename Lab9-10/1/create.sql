create database tusharys_cs545;
\c tusharys_cs545
create table department(
    Dname varchar(15),
    dnumber int not null,
    primary key (Dname)
);

create table employee(
    emp_id int not null,
    Fname varchar(10) not null,
    lname varchar(10) not null,
    Dname varchar(15) not null,
    primary key(emp_id),
    foreign key (Dname ) references department(Dname)
);

CREATE FUNCTION insert_emp()
    returns trigger as $$
    BEGIN
        UPDATE department
        SET dnumber= dnumber+1
        where Dname= NEW.Dname;
        return NEW;
    END;
    $$
    LANGUAGE 'plpgsql';

CREATE FUNCTION delete_emp()
    returns trigger as $$
    BEGIN
        UPDATE department
        SET dnumber= dnumber-1
        where Dname= OLD.Dname;
        return OLD;
    END;
    $$
    LANGUAGE 'plpgsql';

CREATE TRIGGER insertEMPLOYEE
    AFTER INSERT ON employee
    for each ROW
    EXECUTE PROCEDURE insert_emp();

CREATE TRIGGER deleteEMPLOYEE
    BEFORE DELETE ON employee
    for each ROW
    EXECUTE PROCEDURE delete_emp();