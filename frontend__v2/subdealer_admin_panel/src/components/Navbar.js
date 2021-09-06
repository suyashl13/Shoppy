import React, { useContext } from 'react'
import { Link } from 'react-router-dom';
import { toast } from 'react-toastify';
import { loginContext } from '../contexts/LoginContext'
import { logoutAtBackend } from '../helpers/BackendAuthHelper';

export default function Navbar() {

    const { isLoggedIn, setisLoggedIn } = useContext(loginContext);

    return (
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
            <div className="container">
                <Link to='/' className='navbar-brand'>Subdealer Administration</Link>
                <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>
                <div className="collapse navbar-collapse" id="navbarNav">
                    <ul className="navbar-nav">
                        {
                            isLoggedIn ? <>
                                <li className="nav-item">
                                    <Link to='/profile' className='nav-link'>Profile</Link>
                                </li>
                                <li className="nav-item">
                                    <Link to='/orders' className='nav-link'>All Orders</Link>
                                </li>
                                <li className="nav-item">
                                    <Link to='/products' className='nav-link'>Products</Link>
                                </li>
                                <li className="nav-item">
                                    <Link to='/login' onClick={
                                        e => {
                                            logoutAtBackend({
                                                onSuccess: () => {
                                                    toast("Logged out.", {
                                                        type: 'info'
                                                    })
                                                },
                                                onError: (err) => {
                                                    toast("Unable to clear session.", {
                                                        type: 'error'
                                                    })
                                                }
                                            })
                                            localStorage.clear()
                                            setisLoggedIn(false)
                                            window.location.reload();
                                        }
                                    } className='nav-link'>Logout</Link>
                                </li>
                            </> : <>
                                <li className="nav-item">
                                    <Link to='/login' className='nav-link'>Login (Subdealer)</Link>
                                </li>
                                <li className="nav-item">
                                    <Link to='/register' className='nav-link'>Register (Subdealer)</Link>
                                </li>
                            </>
                        }
                    </ul>
                </div>
            </div>
        </nav>
    )
}
