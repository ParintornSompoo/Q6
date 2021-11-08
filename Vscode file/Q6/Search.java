import java.io.File;
public class Search {
    public static String search_file(String rootpath) {
        File f = new File(rootpath);
        File[] files = f.listFiles();
        if (files != null && files.length > 0) {
            for (File file : files) {
                if (file != null) {
                    String path = rootpath + "/" + file.getName();
                    return path;
                        }
                if (file.isDirectory()) {
                    System.out.println("Processing in " + file.getAbsolutePath());
                    String path = search_file(file.getAbsolutePath());
                    if (path != null) {
                        return path;
                }
                    }
                }
            }
        return null;
    }

    public static void main(String[] args) {
        search_file("Workfiles");
    }
}
