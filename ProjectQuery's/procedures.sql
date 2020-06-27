/********************Query 1 procedures******************/
GO 
CREATE PROCEDURE insertCustomer
    @firstName  VARCHAR(20),
    @lastName   VARCHAR(20),
    @streetNum  INT,
    @streetName VARCHAR(20),
    @city       VARCHAR(20),
    @state      VARCHAR(2),
    @zip        INT,
    @category   TINYINT
AS
BEGIN
    INSERT INTO customer
        (firstname, lastname, streetNumber, streetName, city, state, zip, category)
    VALUES
        (@firstName, @lastName, @streetNum, @streetName, @city, @state, @zip, @category)

END

/********************Query x procedures******************/

GO 
CREATE PROCEDURE createNewDepartment
    @deptNum  SMALLINT,
    @budget   INT
AS
BEGIN
    INSERT INTO department
        (dept_number, budget)
    VALUES
        (@deptNum, @budget)
END


CREATE TABLE assembly(
    assembly_id         INT             PRIMARY KEY,
    date_ordered        INT             NOT NULL, 
    assembly_model      VARCHAR(3)      NOT NULL,
    assembly_size       CHAR            NOT NULL,
    firstname          VARCHAR(20)     NOT NULL,
    lastname           VARCHAR(20)     NOT NULL,
    CONSTRAINT FK_Customer FOREIGN KEY (firstname, lastname) REFERENCES Customer(firstname, lastname),
);

GO 
CREATE PROCEDURE newAssembly
    @assembly_id        INT,
    @date_ordered       INT,
    @assembly_model     VARCHAR(3),
    @assembly_size      CHAR,
    @firstname          VARCHAR(20),
    @lastname           VARCHAR(20)
AS
BEGIN
    INSERT INTO assembly
        (assembly_id, date_ordered, assembly_model, assembly_size, firstname, lastname)
    VALUES
        (@assembly_id, @date_ordered, @assembly_model, @assembly_size, @firstname, @lastname)
END


GO 
CREATE PROCEDURE insertNewProcess
    @process_id         INT,
    @assembly_id        INT,
    @dept_number        INT,
    @cost               INT
AS
BEGIN
    INSERT INTO process
        (process_id, assembly_id, dept_number, cost)
    VALUES
        (@process_id, @assembly_id, @dept_number, @cost)
END


GO 
CREATE PROCEDURE insertNewFitProcess
    @process_id         INT,
    @type               CHAR
AS
BEGIN
    INSERT INTO fit_process
        (process_id, type)
    VALUES
        (@process_id, @type)
END
-----------------------------------------------------------------------------------------------
GO 
CREATE PROCEDURE insertNewFitAndProcces
    @process_id         INT,
    @assembly_id        INT,
    @dept_number        INT,
    @cost               INT,
    @type               CHAR
AS
BEGIN
    INSERT INTO process
        (process_id, assembly_id, dept_number, cost)
    VALUES
        (@process_id, @assembly_id, @dept_number, @cost)

        INSERT INTO fit_process
        (process_id, type)
    VALUES
        (@process_id, @type)
END

GO 
CREATE PROCEDURE insertProccesPaint
    @process_id         INT,
    @assembly_id        INT,
    @dept_number        INT,
    @cost               INT,
    @type               TINYINT,
    @method             VARCHAR(8)
AS
BEGIN
    INSERT INTO process
        (process_id, assembly_id, dept_number, cost)
    VALUES
        (@process_id, @assembly_id, @dept_number, @cost)

    INSERT INTO paint_process
        (process_id, type, method)
    VALUES
        (@process_id, @type, @method)
END

-------------------------------Cut proccess----------------------

GO 
CREATE PROCEDURE insertProccesCut
    @process_id         INT,
    @assembly_id        INT,
    @dept_number        INT,
    @cost               INT,
    @cut_type           TINYINT,
    @machine            VARCHAR(8)
AS
BEGIN
    INSERT INTO process
        (process_id, assembly_id, dept_number, cost)
    VALUES
        (@process_id, @assembly_id, @dept_number, @cost)

    INSERT INTO cut_process
        (process_id, cut_type, machine)
    VALUES
        (@process_id, @cut_type, @machine)
END

/********************Query 5 procedures******************/
GO
CREATE PROCEDURE createProcessAccount
    @account_number INT,
    @date_established INT,
    @process_id INT   
AS
BEGIN
    INSERT INTO account 
        (account_number, date_established)
    VALUES
        (@account_number, @date_established)
    INSERT INTO process_account
        (account_number, process_id)
    VALUES
        (@account_number, @process_id)
END
------------------------------------------
GO 
CREATE PROCEDURE createAssemblyAccount
    @account_number INT,
    @date_established INT,
    @assembly_id    INT
AS
BEGIN
    INSERT INTO account 
        (account_number, date_established)
    VALUES
        (@account_number, @date_established)
    INSERT INTO assembly_account
        (account_number, assembly_id)
    VALUES
        (@account_number, @assembly_id)
END
----------------------------------------------
GO
CREATE PROCEDURE createDepartmentAccount
    @account_number INT,
    @date_established INT,
    @dept_number    SMALLINT
AS
BEGIN
    INSERT INTO account 
        (account_number, date_established)
    VALUES
        (@account_number, @date_established)
    INSERT INTO department_account
        (account_number, dept_number)
    VALUES
        (@account_number, @dept_number)
END

/********************Query 6 procedures******************/
GO
CREATE PROCEDURE enterNewJob
    @job_num INT,
    @process_id INT,
    @date_commenced INT
AS
BEGIN
    INSERT INTO job
        (job_num, process_id, date_commenced)
    VALUES
        (@job_num, @process_id, @date_commenced)
END
        

/********************Query 7 procedures******************/
GO
CREATE PROCEDURE enterCompletedCutJob
    @job_num INT,
    @date_completed INT,
    @machine_used VARCHAR(20),
    @time_used INT,
    @material_used VARCHAR(20),
    @labor_time INT
AS
BEGIN
    INSERT INTO cut_job
        (job_num, machine_used, time_used, material_used, labor_time)
    VALUES
        (@job_num, @machine_used, @time_used, @material_used, @labor_time)

    UPDATE job
    SET date_completed = @date_completed
    where job_num = @job_num
END
------------------------------------------------
GO
CREATE PROCEDURE enterCompletedPaintJob
    @job_num INT,
    @date_completed INT,
    @color VARCHAR(10),
    @volume INT,
    @labor_time INT
AS
BEGIN
    INSERT INTO paint_job
        (job_num, color, volume, labor_time)
    VALUES
        (@job_num, @color, @volume, @labor_time)

    UPDATE job
    SET date_completed = @date_completed
    where job_num = @job_num
END
------------------------------------------------------
GO
CREATE PROCEDURE enterCompletedFitJob
    @job_num INT,
    @date_completed INT,
    @labor_time INT
AS
BEGIN
    INSERT INTO fit_job
        (job_num, labor_time)
    VALUES
        (@job_num, @labor_time)

    UPDATE job
    SET date_completed = @date_completed
    where job_num = @job_num
END

/********************Query 8 procedures******************/
/********************Query 9 procedures******************/
/********************Query 10 procedures******************/
/********************Query 11 procedures******************/
/********************Query 12 procedures******************/
GO
CREATE PROCEDURE retrieveJobinRangeAndDept
    @date INT,
    @dept_number SMALLINT
AS
BEGIN
    
    

    select * from job
    where process_id in (select process_id from process
                            where dept_number = @dept_number)
    
END





/********************Query 13 procedures******************/
GO 
CREATE PROCEDURE retrieveCustomerInRange
    @min TINYINT,
    @max TINYINT
AS
BEGIN
    SELECT * FROM customer
    where (category >= @min AND category <= @max)
    ORDER BY firstname, lastname
END

/********************Query 14 procedures******************/
GO 
CREATE PROCEDURE deleteCutJobsInRange
    @startDate INT,
    @stopDate INT
AS
BEGIN
    DELETE from cut_job
    where job_num in (select job_num from job 
                        where (date_commenced >= @startDate AND date_commenced <= @stopDate) OR
                                (date_completed >= @startDate AND date_completed <= @stopDate))

    DELETE FROM job
    where (date_commenced >= @startDate AND date_commenced <= @stopDate) OR
                                (date_completed >= @startDate AND date_completed <= @stopDate)    

END
/********************Query 15 procedures******************/
GO
CREATE PROCEDURE changePaintColor
    @job_num INT,
    @color   VARCHAR(10)
AS
BEGIN
    UPDATE paint_job
    set color = @color
    where job_num = @job_num
END
 



 -----Might have done forgin key constrains wrong
 ---check to see if the fk constraint goes in the reference table or the referencing table