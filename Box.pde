public class Box {
    int width;
    int height;
    int length;
    int id;
    boolean isLoaded;

    Box(int w, int h, int l, int n) {
        this.width = w;
        this.height = h;
        this.length = l;
        this.id = n;
        this.isLoaded = false;
    }

    void rotate() {
        int tmp = 0;
        tmp = this.width;
        this.width = length;
        this.length = tmp;
    }

    public void setIsLoaded(boolean x) {
        this.isLoaded = x;
    }
    
    public boolean getIsLoaded(){
        return this.isLoaded;
    }

    public int getVolume() {
        return this.width * this.height * this.length;
    }
}
