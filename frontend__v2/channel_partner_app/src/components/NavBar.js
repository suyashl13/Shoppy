import React, { useContext } from 'react'
import { Link } from 'react-router-dom'
import { toast } from 'react-toastify'
import { loginContext } from '../contexts/loginContext'
import { logoutAtBackend } from '../helpers/BackendAuthHelpers'

export default function NavBar() {

    const { isLoggedIn, setIsLoggedIn } = useContext(loginContext)

    return (
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
            <div className="container-fluid">
                <Link to='/' className='navbar-brand'>Channel Partner App</Link>
                <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>
                <div className="collapse navbar-collapse" id="navbarTogglerDemo01">
                    <ul className="navbar-nav me-auto mb-2 mb-lg-0">
                        {
                            isLoggedIn ? <li className="nav-item">
                                <Link
                                    onClick={
                                        async () => {
                                            await logoutAtBackend({
                                                onSuccess: () => {
                                                    localStorage.clear();
                                                    setIsLoggedIn(false)
                                                    toast("Logged out Successfully..", { type: 'info' })
                                                },
                                                onError: () => {
                                                    localStorage.clear();
                                                    setIsLoggedIn(false)
                                                    toast("Unable to clear session.", { type: 'error' })
                                                },
                                            })
                                        }
                                    }
                                    className="nav-link" to='/login'>logout</Link>
                            </li> :
                                <>
                                    <li className="nav-item"><Link className="nav-link" to='/login'>Login</Link></li>
                                    <li className="nav-item"><Link className="nav-link" to='/signup'>Sign-up</Link></li>
                                </>
                        }
                    </ul>
                </div>
            </div>
        </nav>
    )
}
