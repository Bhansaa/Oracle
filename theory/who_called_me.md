# Record the Package/procedure name in log table

```sql
create or replace TRIGGER wms_bintsf_detail_biur_audit
   BEFORE INSERT OR UPDATE OR DELETE
   ON wms_bintsf_detail
   REFERENCING NEW AS new OLD AS old
   FOR EACH ROW
DECLARE
   l_action_ind           wms_bintsf_detail_audit.action_ind%TYPE;
   l_wave_id              wms_bintsf_head.wave_id%TYPE;
   l_tsf_type             wms_bintsf_head.tsf_type%TYPE;
   l_dc_code              wms_bintsf_detail_audit.dc_code%TYPE;
   l_tsf_no               wms_bintsf_detail_audit.tsf_no%TYPE;
   l_line_no              wms_bintsf_detail_audit.line_no%TYPE;
   l_item                 wms_bintsf_detail_audit.item%TYPE;
   l_from_storer          wms_bintsf_detail_audit.from_storer%TYPE;
   l_from_bin_code        wms_bintsf_detail_audit.from_bin_code%TYPE;
   l_from_lot             wms_bintsf_detail_audit.from_lot%TYPE;
   l_from_pallet_id       wms_bintsf_detail_audit.from_pallet_id%TYPE;
   l_to_storer            wms_bintsf_detail_audit.to_storer%TYPE;
   l_to_bin_code          wms_bintsf_detail_audit.to_bin_code%TYPE;
   l_to_lot               wms_bintsf_detail_audit.to_lot%TYPE;
   l_to_pallet_id         wms_bintsf_detail_audit.to_pallet_id%TYPE;
   l_to_packkey           wms_bintsf_detail_audit.to_packkey%TYPE;
   l_to_batch             wms_bintsf_detail_audit.to_batch%TYPE;
   l_to_consignee         wms_bintsf_detail_audit.to_consignee%TYPE;
   l_to_fifo_date         wms_bintsf_detail_audit.to_fifo_date%TYPE;
   l_to_sell_by_date      wms_bintsf_detail_audit.to_sell_by_date%TYPE;
   l_to_mfg_date          wms_bintsf_detail_audit.to_mfg_date%TYPE;
   l_to_order_type        wms_bintsf_detail_audit.to_order_type%TYPE;
   l_to_attribute_1       wms_bintsf_detail_audit.to_attribute_1%TYPE;
   l_to_attribute_2       wms_bintsf_detail_audit.to_attribute_2%TYPE;
   l_to_attribute_3       wms_bintsf_detail_audit.to_attribute_3%TYPE;
   l_to_attribute_4       wms_bintsf_detail_audit.to_attribute_4%TYPE;
   l_to_attribute_5       wms_bintsf_detail_audit.to_attribute_5%TYPE;
   l_req_qty              wms_bintsf_detail_audit.req_qty%TYPE;
   l_tsf_qty              wms_bintsf_detail_audit.tsf_qty%TYPE;
   l_status               wms_bintsf_detail_audit.status%TYPE;
   l_reject_reason        wms_bintsf_detail_audit.reject_reason%TYPE;
   l_assignment_id        wms_bintsf_detail_audit.assignment_id%TYPE;
   l_assignment_line_no   wms_bintsf_detail_audit.assignment_line_no%TYPE;
   l_to_dc_code           wms_bintsf_detail_audit.to_dc_code%TYPE;
   l_orig_req_qty         wms_bintsf_detail_audit.req_qty%TYPE;
   l_user_id              wms_bintsf_detail.created_by%TYPE := USER;
  /* Start Madhusudan K on 06-10-2022*/ 
  l_owner VARCHAR2(100);
  l_name VARCHAR2(100);
  l_line PLS_INTEGER;
  l_type VARCHAR2(100);
  /* End Madhusudan K on 06-10-2022*/ 
   CURSOR c_get_wave (p_dc_code    wms_bintsf_head.dc_code%TYPE,
                      p_tsf_no     wms_bintsf_head.tsf_no%TYPE)
   IS
      SELECT wave_id, tsf_type
        FROM wms_bintsf_head
       WHERE dc_code = p_dc_code AND tsf_no = p_tsf_no;

   l_error_message        wms_errors.error_message%TYPE;
   l_audit_bintsf         wms_dc_sysprm.sys_conf_value%TYPE;
   l_program_name         wms_errors.program_name%TYPE
                             := 'WMS_BINTSF_DETAIL_BIUR_AUDIT';
   e_error                EXCEPTION;
BEGIN
    /* Start Madhusudan K on 06-10-2022*/ 
    owa_util.who_called_me(l_owner,l_name,l_line,l_type);
	
    /* End Madhusudan K on 06-10-2022*/
    
   IF INSERTING
   THEN
      l_action_ind := 'A';
      l_dc_code := :new.dc_code;
      l_tsf_no := :new.tsf_no;
   ELSIF UPDATING
   THEN
      l_action_ind := 'U';
      l_dc_code := :new.dc_code;
      l_tsf_no := :new.tsf_no;
   ELSE
      l_action_ind := 'D';
      l_dc_code := :old.dc_code;
      l_tsf_no := :old.tsf_no;
   END IF;

   IF NOT wms_dc_sql.get_dc_sysprm (l_error_message,
                                    l_audit_bintsf,
                                    l_dc_code,
                                    'AUDIT_BINTSF')
   THEN
      RAISE e_error;
   END IF;

   IF NVL (l_audit_bintsf, 'N') = 'Y'
   THEN
      OPEN c_get_wave (l_dc_code, l_tsf_no);

      FETCH c_get_wave
      INTO l_wave_id, l_tsf_type;

      IF c_get_wave%NOTFOUND
      THEN
         NULL;
      END IF;

      CLOSE c_get_wave;

      IF l_tsf_type IN ('R', 'M')
      THEN
         IF DELETING
         THEN
            l_dc_code := :old.dc_code;
            l_tsf_no := :old.tsf_no;
            l_line_no := :old.line_no;
            l_item := :old.item;
            l_from_storer := :old.from_storer;
            l_from_bin_code := :old.from_bin_code;
            l_from_lot := :old.from_lot;
            l_from_pallet_id := :old.from_pallet_id;
            l_to_storer := :old.to_storer;
            l_to_bin_code := :old.to_bin_code;
            l_to_lot := :old.to_lot;
            l_to_pallet_id := :old.to_pallet_id;
            l_to_packkey := :old.to_packkey;
            l_to_batch := :old.to_batch;
            l_to_consignee := :old.to_consignee;
            l_to_fifo_date := :old.to_fifo_date;
            l_to_sell_by_date := :old.to_sell_by_date;
            l_to_mfg_date := :old.to_mfg_date;
            l_to_order_type := :old.to_order_type;
            l_to_attribute_1 := :old.to_attribute_1;
            l_to_attribute_2 := :old.to_attribute_2;
            l_to_attribute_3 := :old.to_attribute_3;
            l_to_attribute_4 := :old.to_attribute_4;
            l_to_attribute_5 := :old.to_attribute_5;
            l_req_qty := :old.req_qty;
            l_tsf_qty := :old.tsf_qty;
            l_status := :old.status;
            l_reject_reason := :old.reject_reason;
            l_assignment_id := :old.assignment_id;
            l_assignment_line_no := :old.assignment_line_no;
            l_to_dc_code := :old.to_dc_code;
            l_orig_req_qty := :old.orig_req_qty;
         ELSE
            l_dc_code := :new.dc_code;
            l_tsf_no := :new.tsf_no;
            l_line_no := :new.line_no;
            l_item := :new.item;
            l_from_storer := :new.from_storer;
            l_from_bin_code := :new.from_bin_code;
            l_from_lot := :new.from_lot;
            l_from_pallet_id := :new.from_pallet_id;
            l_to_storer := :new.to_storer;
            l_to_bin_code := :new.to_bin_code;
            l_to_lot := :new.to_lot;
            l_to_pallet_id := :new.to_pallet_id;
            l_to_packkey := :new.to_packkey;
            l_to_batch := :new.to_batch;
            l_to_consignee := :new.to_consignee;
            l_to_fifo_date := :new.to_fifo_date;
            l_to_sell_by_date := :new.to_sell_by_date;
            l_to_mfg_date := :new.to_mfg_date;
            l_to_order_type := :new.to_order_type;
            l_to_attribute_1 := :new.to_attribute_1;
            l_to_attribute_2 := :new.to_attribute_2;
            l_to_attribute_3 := :new.to_attribute_3;
            l_to_attribute_4 := :new.to_attribute_4;
            l_to_attribute_5 := :new.to_attribute_5;
            l_req_qty := :new.req_qty;
            l_tsf_qty := :new.tsf_qty;
            l_status := :new.status;
            l_reject_reason := :new.reject_reason;
            l_assignment_id := :new.assignment_id;
            l_assignment_line_no := :new.assignment_line_no;
            l_to_dc_code := :new.to_dc_code;

            IF UPDATING
            THEN
               l_orig_req_qty := :new.orig_req_qty;
            ELSE
               l_orig_req_qty := :new.req_qty;
            END IF;
         END IF;

         IF ( (l_action_ind IN ('A', 'U'))
             OR (l_action_ind = 'D' AND l_status IN ('I', 'S', 'P')))
         THEN
            INSERT INTO wms_bintsf_detail_audit (dc_code,
                                                 wave_id,
                                                 tsf_type,
                                                 tsf_no,
                                                 line_no,
                                                 item,
                                                 from_storer,
                                                 from_bin_code,
                                                 from_lot,
                                                 from_pallet_id,
                                                 to_storer,
                                                 to_bin_code,
                                                 to_lot,
                                                 to_pallet_id,
                                                 to_packkey,
                                                 to_batch,
                                                 to_consignee,
                                                 to_fifo_date,
                                                 to_sell_by_date,
                                                 to_mfg_date,
                                                 to_order_type,
                                                 to_attribute_1,
                                                 to_attribute_2,
                                                 to_attribute_3,
                                                 to_attribute_4,
                                                 to_attribute_5,
                                                 req_qty,
                                                 tsf_qty,
                                                 status,
                                                 reject_reason,
                                                 assignment_id,
                                                 assignment_line_no,
                                                 to_dc_code,
                                                 orig_req_qty,
                                                 user_id,
                                                 action_ind,
                                                 dml_timestamp,
                                                 seq_no,
												 source) -- Added by Madhusudan K on 06-10-2022
                 VALUES (l_dc_code,
                         l_wave_id,
                         l_tsf_type,
                         l_tsf_no,
                         l_line_no,
                         l_item,
                         l_from_storer,
                         l_from_bin_code,
                         l_from_lot,
                         l_from_pallet_id,
                         l_to_storer,
                         l_to_bin_code,
                         l_to_lot,
                         l_to_pallet_id,
                         l_to_packkey,                         
                         l_to_batch,
                         l_to_consignee,
                         l_to_fifo_date,
						 l_to_sell_by_date,
                         l_to_mfg_date,
                         l_to_order_type,
                         l_to_attribute_1,
                         l_to_attribute_2,
                         l_to_attribute_3,
                         l_to_attribute_4,
                         l_to_attribute_5,
                         l_req_qty,
                         l_tsf_qty,
                         l_status,
                         l_reject_reason,
                         l_assignment_id,
                         l_assignment_line_no,
                         l_to_dc_code,
                         l_orig_req_qty,
                         l_user_id,
                         l_action_ind,
                         SYSDATE,
                         wms_bintsf_detail_audit_seq.NEXTVAL,
						 (l_owner||'.'||l_name||' Line: '||l_line) -- Added by Madhusudan K on 06-10-2022
						 );
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN e_error
   THEN
      raise_application_error (
         -20001,
         'Raised from ' || l_program_name || ' :- ' || l_error_message);
   WHEN OTHERS
   THEN
      raise_application_error (
         -20001,
         'Raised from ' || l_program_name || ' :- ' || SQLERRM);
END;
```
