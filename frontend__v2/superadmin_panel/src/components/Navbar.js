import React, { useContext } from 'react'
import { Link } from 'react-router-dom';
import { LoginContext } from '../contexts/AuthContext';

export default function Navbar() {

    const { setIsLoggedIn } = useContext(LoginContext)

    return (
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
            <div className="container">
                <Link className="navbar-brand" to='/'>Superadmin Dashboard</Link>
                <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>
                <div className="collapse navbar-collapse justify-content-end" id="navbarNav">
                    <ul className="navbar-nav">
                        <li className="nav-item">
                            <Link className="nav-link" aria-current="page" to='/users'>Users</Link>
                        </li>
                        <li className="nav-item">
                            <Link className="nav-link" aria-current="page" to="/products">Products</Link>
                        </li>
                        <li className="nav-item">
                            <Link className="nav-link" aria-current="page" to="/subdealers">Subdealers</Link>
                        </li>
                        {/* <li className="nav-item">
                            <Link className="nav-link" aria-current="page" to="/channel_partners">Channel Partners</Link>
                        </li> */}
                        <li className="nav-item">
                            <Link className="nav-link" aria-current="page" onClick={
                                () => {
                                    setIsLoggedIn(false)
                                    localStorage.clear()
                                }
                            } to="/login">Logout</Link>
                        </li>

                    </ul>
                </div>
            </div>
        </nav>
    )
}
