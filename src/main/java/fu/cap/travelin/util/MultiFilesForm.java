package fu.cap.travelin.util;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class MultiFilesForm {
    private List<MultipartFile> files;

    public List<MultipartFile> getFiles() {
        return files;
    }

    public void setFiles(List<MultipartFile> files) {
        this.files = files;
    }

    public MultiFilesForm() {
        new ArrayList<MultipartFile>();
    }

    public MultiFilesForm(List<MultipartFile> files) {
        this.files = files;
    }
}
