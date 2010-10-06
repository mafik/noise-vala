namespace Drips {
	class Noise {
		private static const int RANDOM_LENGTH = 0x100 + 0x100 + 2;
		private double[,] g1;
		private double[,] g2;
		private double[,] g3;
		private void init() {
			g1 = new double[RANDOM_LENGTH,1];
			g2 = new double[RANDOM_LENGTH,2];
			g3 = new double[RANDOM_LENGTH,3];
			for (int i = 0 ; i < 0x100 ; i++) {
				double sq;
				g1[i] = Random.next_double()*2-1;
				for (int j = 0 ; j < 2 ; j++)
					g2[i,j] = Random.next_double()*2-1;
				sq = Math.sqrt(g2[i,0]*g2[i,0]+g2[i,1]*g2[i,1]);
				g2[i,0] /= sq;
				g2[i,1] /= sq;
				for (int j = 0 ; j < 3 ; j++)
					g3[i,j] = Random.next_double()*2-1;
				sq = Math.sqrt(g3[i,0]*g3[i,0]+g3[i,1]*g3[i,1]+g3[i,2]*g3[i,2]);
				g3[i,0] /= sq;
				g3[i,1] /= sq;
				g3[i,2] /= sq;
			}
			for (int i = 0 ; i < 0x100 + 2 ; i++) {
				g1[0x100 + i] = g1[i];
				for (int j = 0 ; j < 2 ; j++)
					g2[0x100 + i,j] = g2[i,j];
				for (int j = 0 ; j < 3 ; j++)
					g3[0x100 + i,j] = g3[i,j];
			}

		}
		public Noise.random() {
			init();
		}
		public Noise.from_seed(uint seed) {
			init();
		}
		public double get_1d(double x) {
			int left_key = ((int)x) & 0xff;
			int right_key = (left_key+1) & 0xff;
			double rem = x - (int)x;
			double interpolator = rem * rem * (3.0 - 2.0 * rem);
			double left = g1[ left_key ];
			double right = g1[ right_key ];
			return ( left + interpolator * (right - left) );
		}
		public double get_2d(double x, double y) {
			int bx0, bx1, by0, by1, b00, b10, b01, b11;
			double rx0, rx1, ry0, ry1, sx, sy, a, b, u, v;
			bx0 = ((int)x) & 0xff; bx1 = (bx0+1) & 0xff; rx0 = x - (int)x; rx1 = rx0 - 1.0;
			by0 = ((int)y) & 0xff; by1 = (by0+1) & 0xff; ry0 = y - (int)y; ry1 = ry0 - 1.0;
			b00 = bx0 + by0;
			b10 = bx1 + by0;
			b01 = bx0 + by1;
			b11 = bx1 + by1;
			sx = ( rx0 * rx0 * (3.0 - 2.0 * rx0) );
			sy = ( ry0 * ry0 * (3.0 - 2.0 * ry0) );
			
			u = ( rx0 * g2[b00,0] + ry0 * g2[b00,1] );
			v = ( rx1 * g2[b10,0] + ry0 * g2[b10,1] );
			a = ( u + sx * (v - u) );
			u = ( rx0 * g2[b01,0] + ry1 * g2[b01,1] );
			v = ( rx1 * g2[b11,0] + ry1 * g2[b11,1] );
			b = ( u + sx * (v - u) );
			return ( a + sy * (b - a) );
		}
	}
}