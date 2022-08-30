                                        *************************************
                                                 delete_duplicate
                                        *************************************



delete from mw_rf_stock_take_result
    where rowid not in 
( select min(rowid) from 
        mw_rf_stock_take_result
      where req_no='S000002248' and BIN_SECTION in('AA3')
      group by bin_code)
  and req_no='S000002248' and BIN_SECTION in('AA3')
  
