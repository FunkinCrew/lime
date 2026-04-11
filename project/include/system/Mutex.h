#pragma once

namespace lime {


	class Mutex {


		public:

			Mutex ();
			~Mutex ();

			void Lock () const;
			bool TryLock () const;
			void Unlock () const;

		private:

			void* mutex;


	};


}