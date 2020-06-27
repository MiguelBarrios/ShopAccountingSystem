---------------------------Query 1 ---------------------------------------
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

---------------------------Query 2 ---------------------------------------
GO 
CREATE PROCEDURE createNewDepartment
    @deptNum    SMALLINT,
    @name       VARCHAR(20),
    @budget     INT
AS
BEGIN
    INSERT INTO department
        (dept_number, dept_name, total_cost, budget)
    VALUES
        (@deptNum, @name,0, @budget)
END


---------------------------Query 3 ---------------------------------------=
GO 
CREATE PROCEDURE createNewAssembly
    @assembly_id        INT,
    @date_ordered       INT,
    @model              VARCHAR(3),
    @firstname          VARCHAR(20),
    @lastname           VARCHAR(20)
AS
BEGIN
    INSERT INTO assembly
        (assembly_id, date_ordered, MODULE, total_cost, firstname, lastname)
    VALUES
        (@assembly_id, @date_ordered,@model, 0, @firstname, @lastname)
END

---------------------------Query 4 ---------------------------------------
GO 
CREATE PROCEDURE createNewFitProcces
    @process_id         INT,
    @dept_number        INT,
    @type               CHAR(1)
AS
BEGIN
    INSERT INTO process
        (process_id, dept_number, total_cost, type)
    VALUES
        (@process_id, @dept_number, 0, @type)
    INSERT INTO process_fit
        (process_id, fit_type)
    VALUES
        (@process_id, @type)
END

GO 
CREATE PROCEDURE createProccesPaint
    @process_id         INT,
    @dept_number        INT,
    @type               char(1),
    @paintType          TINYINT,
    @method             VARCHAR(8)
AS
BEGIN
    INSERT INTO process
        (process_id, dept_number, total_cost, type)
    VALUES
        (@process_id, @dept_number, 0, @type)

    INSERT INTO process_paint
        (process_id, paint_type, paint_method)
    VALUES
        (@process_id, @paintType, @method)
END

GO 
CREATE PROCEDURE createProccesCut
    @process_id         INT,
    @dept_number        INT,
    @cut_type           TINYINT,
    @machine            VARCHAR(20),
    @type              char(1)
AS
BEGIN
    INSERT INTO process
        (process_id, dept_number, total_cost, type)
    VALUES
        (@process_id, @dept_number, 0, @type)

    INSERT INTO process_cut
        (process_id, cut_type, machine)
    VALUES
        (@process_id, @cut_type, @machine)
END

---------------------------Query 5 ---------------------------------------
GO
CREATE PROCEDURE createProcessAccount
    @account_number INT,
    @date_established INT,
    @process_id INT   
AS
BEGIN
    INSERT INTO account 
        (account_number)
    VALUES
        (@account_number)
    INSERT INTO account_process
        (account_number, process_id, date_established)
    VALUES
        (@account_number, @process_id, @date_established)
END

GO 
CREATE PROCEDURE createAssemblyAccount
    @account_number INT,
    @date_established INT,
    @assembly_id    INT
AS
BEGIN
    INSERT INTO account 
        (account_number)
    VALUES
        (@account_number)
    INSERT INTO account_assembly
        (account_number, assembly_id, date_established)
    VALUES
        (@account_number, @assembly_id, @date_established)
END

GO
CREATE PROCEDURE createDepartmentAccount
    @account_number INT,
    @date_established INT,
    @dept_number    SMALLINT
AS
BEGIN
    INSERT INTO account 
        (account_number)
    VALUES
        (@account_number)
    INSERT INTO account_department
        (account_number, dept_number, date_established)
    VALUES
        (@account_number, @dept_number, @date_established)
END

---------------------------Query 6 ---------------------------------------
GO
CREATE PROCEDURE newJob
    @job_num INT,
    @process_id INT,
    @assembly_id INT,
    @date_commenced INT
AS
BEGIN
    INSERT INTO job
        (job_num, process_id, assembly_id, date_commenced)
    VALUES
        (@job_num, @process_id,@assembly_id, @date_commenced)
END
---------------------------Query 7 ---------------------------------------
GO
CREATE PROCEDURE completedCutJob
    @job_num INT,
    @date_completed INT,
    @machine_used VARCHAR(20),
    @time_used INT,
    @material_used VARCHAR(20),
    @labor_time INT
AS
BEGIN
    IF EXISTS(SELECT job_num from job where job_num = @job_num)
    BEGIN
    INSERT INTO job_cut
        (job_num, machine_used, time_used, material_used, labor_time)
    VALUES
        (@job_num, @machine_used, @time_used, @material_used, @labor_time)

    UPDATE job
    SET date_completed = @date_completed
    where job_num = @job_num
    END
END


GO
CREATE PROCEDURE completedPaintJob
    @job_num INT,
    @date_completed INT,
    @color VARCHAR(10),
    @volume INT,
    @labor_time INT
AS
BEGIN
    IF EXISTS(SELECT job_num from job where job_num = @job_num)
    BEGIN
    INSERT INTO job_paint
        (job_num, color, volume, labor_time)
    VALUES
        (@job_num, @color, @volume, @labor_time)

    UPDATE job
    SET date_completed = @date_completed
    where job_num = @job_num
    END
END


GO
CREATE PROCEDURE completedFitJob
    @job_num INT,
    @date_completed INT,
    @labor_time INT
AS
BEGIN
    IF EXISTS(SELECT job_num from job where job_num = @job_num)
    BEGIN
    INSERT INTO job_fit
        (job_num, labor_time)
    VALUES
        (@job_num, @labor_time)

    UPDATE job
    SET date_completed = @date_completed
    where job_num = @job_num
    END
END

---------------------------Query 8 ---------------------------------------
GO
CREATE PROCEDURE newTransaction
    @transaction_number BIGINT,
    @job_num INT,
    @totalCost  DECIMAL(10,2)
AS
BEGIN
    INSERT INTO transactions
        (transaction_number, supply_cost, job_num)
    VALUES
        (@transaction_number, @totalCost, @job_num)

    Declare @processID INT;
    SET @processID = (select process_id from job where job_num = @job_num);

    update process
    SET total_cost = total_cost + @totalCost
    where process_id = @processID

    update department
    SET total_cost = total_cost + @totalCost
    where dept_number = (select distinct(dept_number) from process where process_id = @processID)

    update assembly
    set total_cost = total_cost + @totalCost
    where assembly_id = (select assembly_id from job where job_num = @job_num)

END

---------------------------Query 9 ---------------------------------------
GO 
CREATE PROCEDURE getCostsAssemblyId
    @assemblyId     INT
AS
BEGIN
    SELECT total_cost FROM assembly
    where assembly_id = @assemblyId
END
---------------------------Query 10 ---------------------------------------
GO 
CREATE PROCEDURE totalLaborByDepOnDate 
    @dept_number SMALLINT,
    @date INT
AS
BEGIN
    select isnull(job_cut.labor_time, 0) + isnull(job_fit.labor_time,0) + isnull(job_paint.labor_time,0)
     FROM job left join job_cut
    ON job.job_num = job_cut.job_num left JOIN job_fit
    on job.job_num = job_fit.job_num left JOIN job_paint
    on job.job_num = job_paint.job_num 
    where process_id in (select process_id from process where dept_number = @dept_number ) AND
    job.date_completed = @date
END
---------------------------Query 11 ---------------------------------------
GO
CREATE PROCEDURE getProcessByAssemblyId
    @assembly_id INT
AS
BEGIN
        select process.process_ID, dept_number 
        from job inner join process
        on job.process_id = process.process_id
        where assembly_id = @assembly_id
END

---------------------------Query 12 ---------------------------------------
GO
CREATE PROCEDURE query12
    @date INT,
    @dept_number TINYINT
AS
BEGIN
    SELECT job.job_num, assembly_id, date_commenced, date_completed, machine_used, time_used, material_used, job_cut.labor_time, job_fit.labor_time, color, volume, job_paint.labor_time                        
    from job, job_cut, job_fit, job_paint
    where date_completed = @date and process_id in (select process_id from process where dept_number = @dept_number)
END
---------------------------Query 13 ---------------------------------------
GO
CREATE PROCEDURE customersInRange
    @min    TINYINT,
    @max    TINYINT
AS
BEGIN
    select * from customer
    where category >= @min and category <= @max
    ORDER BY firstname, lastname ASC
END
---------------------------Query 14 ---------------------------------------
GO                
CREATE PROCEDURE rmCutJobsRange
    @start INT,
    @stop INT
AS
BEGIN
    --Saves all job numbers that need to be removed
    DECLARE @jobNumbers TABLE(jobNumber INT NOT NULL);
    INSERT INTO @jobNumbers (jobNumber)
    select job.job_num from job
    INNER JOIN job_cut on job.job_num = job_cut.job_num
    where job.job_num >= @start and job.job_num <= @stop

    DELETE FROM job_cut where job_num in (select * from @jobNumbers);
END


---------------------------Query 15 ---------------------------------------
GO 
CREATE PROCEDURE updateJobColor
    @job_num INT,
    @color VARCHAR(10)
AS
BEGIN
    UPDATE job_paint
    set color = @color
    where job_num = @job_num
END
