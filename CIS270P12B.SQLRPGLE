000100230423**Free
000101230423
000102230423// **********************************************************************************************
000103230423// This program utilizes embedded SQL to update all sections within the math department.        *
000104230423// It updates the sections by increasing the maximum enrollment by 15%.                         *
000106230423// Then program prints the sections in ascending order of the maxximum enrollment.              *
000107230423//                                                                                              *
000108230427// Programmer: Steven Conyers Date: 4/23/2023    Date Revised:  4/27/2023                       *
000109230423//                                                                                              *
000110230423// **********************************************************************************************
000111230423
000112230426// -----Control Statement----------------------------------
000113230426Ctl-opt option(*srcStmt: *nodebugio);
000114230426
000115230426// ----------Declared Files----------------------
000116230426DCL-F CIS270P12B Printer OfLind(EndOfPage);
000117230426
000118230426//--------Constants-------------------------------
000119230426DCL-C Success   '00000';
000120230426DCL-C EndOfFile '02000';
000121230426
000122230426// --------Declared Standalone Variables----------------
000123230426DCL-S EndOfPage Ind Inz(*On);
000124230426
000125230426// -------External Data Structure------------
000126230426DCL-DS CourseData Extname('MYSECTIONS');
000127230426
000128230426END-DS;
000129230426
000130230426// --------Main Logic------------------------
000131230427// Update the entire file before the loop starts
000133230426Exec SQL UPDATE MYSECTIONS
000134230427SET CAP = CAP + Round(0.15 * CAP) // Increase maximum enrollment by 15%
000136230427WHERE DEPT = 'MTH';
000137230426
000138230426// Fetch and print updated records
000139230426EXEC SQL DECLARE Department CURSOR FOR
000140230427  SELECT *
000141230426  FROM MYSECTIONS
000142230426  WHERE DEPT = 'MTH'
000143230426  ORDER BY CAP ASC;
000144230426
000145230426Exec SQL OPEN Department;
000146230426
000149230426DOU Sqlstate = EndOfFile;
000151230427  Exec SQL FETCH Department INTO :CourseData; // Priming fetch
000152230427
000153230426  Select;
000154230426  When Sqlstate = Success;
000155230426    Exsr PrintDept;
000156230426  When Sqlstate = EndOfFile;
000157230426    Leave;
000158230426  ENDSL;
000159230426
000160230426ENDDO;
000161230426
000162230426Exec SQL CLOSE Department;
000163230426
000164230426*INLR = *On;
000165230426RETURN;
000166230426
000167230426// -------Overflow Subroutine-------------------
000168230426Begsr Overflow;
000169230426  IF EndOfPage;
000170230426    WRITE HEADING;
000171230426    EndOfPage = *Off;
000172230426  ENDIF;
000173230426ENDSR;
000174230426
000175230426// ------Printing Subroutine---------------------
000176230426Begsr PrintDept;
000177230426  Exsr Overflow;
000178230426  WRITE DETAIL;
000179230426ENDSR;
