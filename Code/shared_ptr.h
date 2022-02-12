#ifndef FCSharedPtr_h
#define FCSharedPtr_h

#include <algorithm>
//#include "Core/Util.h"

template<typename T>
class FCSharedPtr {
private:
	unsigned int* m_pRefCount;
	T* m_pT;
	
public:
	
	FCSharedPtr( T* pT = 0 )
	: m_pT( pT )
	{
		m_pRefCount = new unsigned int;
		*m_pRefCount = 1;
	}

	FCSharedPtr( const FCSharedPtr<T> &other )
	: m_pT( other.m_pT )
	, m_pRefCount( other.m_pRefCount )
	{
		(*m_pRefCount)++;
	}
	
	~FCSharedPtr()
	{
		(*m_pRefCount)--;
		if (*m_pRefCount <= 0) {
			SAFE_DELETE_PTR(m_pT);
			delete m_pRefCount;
		}
	}

	FCSharedPtr& operator=( const FCSharedPtr<T> &rhs )
	{
		FCShared<T> temp(rhs);
		swap(temp);
		return *this;
	}

	T& operator*() const
	{
		return *m_pT;
	}

	T* operator->() const
	{
		return m_pT;
	}

	operator bool() const
	{
		return m_pT != 0;
	}
	
	T* get() const
	{
		return m_pT;
	}
	
	void swap( FCSharedPtr<T> &other )
	{
		std::swap( m_pT, other.m_pT );
		std::swap( m_pRefCount, other.m_pRefCount );
	}	
};

#endif
