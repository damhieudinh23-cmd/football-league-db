SELECT 
    tt.MaTT, 
    tt.TenTT 
FROM TRONG_TAI tt
WHERE EXISTS (
    -- Kiểm tra xem trọng tài này có bắt chính trận nào không
    SELECT 1
    FROM PHAN_CONG_TRONG_TAI pctt
    WHERE pctt.MaTT = tt.MaTT 
      AND pctt.VaiTro = 'Trọng tài chính'
      AND EXISTS (
          -- Kiểm tra xem trận đấu mà trọng tài này bắt chính có > 5 thẻ phạt hay không
          SELECT 1
          FROM THE_PHAT tp
          WHERE tp.MaTran = pctt.MaTran
          GROUP BY tp.MaTran
          HAVING COUNT(tp.MaThe) > 5
      )
);