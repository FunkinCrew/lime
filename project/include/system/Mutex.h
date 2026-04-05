#pragma once

namespace lime {


	class Mutex {


		public:

			Mutex ();
			~Mutex ();

			bool Lock () const;
			bool TryLock () const;
			bool Unlock () const;

		private:

			void* mutex;


	};


}