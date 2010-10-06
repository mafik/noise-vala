namespace Drips {
	class Window {
		public static void main(string[] args) {
			for(int a = 0; a<30; ++a) {
				for(int i=0; i<400;++i) {
					for(int j=0; j<400;++j) {
						double x = i/10.0;
						double y = j/10.0;
						double d = SimplexNoise.noise(x, y);
					}
				}
				stdout.puts("cyk!\n");
			}
		}
	}
}