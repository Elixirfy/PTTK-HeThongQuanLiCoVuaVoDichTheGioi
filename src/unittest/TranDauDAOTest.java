package unittest;

import dao.TranDauDAO;
import model.TranDau;
import model.VongDau;
import model.BanDau;
import java.util.ArrayList;

public class TranDauDAOTest {

    public void testSearchTranDauTheoBanStandard() {
        TranDauDAO dao = new TranDauDAO();
        TranDau criteria = new TranDau();
        VongDau vd = new VongDau();
        vd.setId(105);
        criteria.setVongDau(vd);

        BanDau bd = new BanDau();
        bd.setSoBan("11");
        criteria.setBanDau(bd);

        ArrayList<TranDau> list = dao.searchTranDauTheoBan(criteria);
        System.out.println("Kết quả tìm kiếm bàn 11: " + list.size());
    }

    public void testGetChiTietTranDau() {
        TranDauDAO dao = new TranDauDAO();
        TranDau td = dao.getChiTietTranDau(1101);
        System.out.println("Chi tiết trận 1101: " + (td != null ? td.getId() : "null"));
    }

    public static void main(String[] args) {
        TranDauDAOTest test = new TranDauDAOTest();
        test.testSearchTranDauTheoBanStandard();
        test.testGetChiTietTranDau();
    }
}

