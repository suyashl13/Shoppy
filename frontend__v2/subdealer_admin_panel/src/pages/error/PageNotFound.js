import React from 'react'
import { Link } from 'react-router-dom'

export default function PageNotFound() {
    return (
        <div className='container p-5'>
            <div className="p-5 mb-4 bg-light rounded-3">
                <div className="container-fluid py-5">
                    <h1 className="display-5 fw-bold">404 - Page Not Found</h1>
                    <hr className='my-4' />
                    <p className="col-md-8 fs-4">
                        Sorry! We could'nt find that page. Try visiting our <Link to='/'>Homepage</Link>.
                    </p>
                </div>
            </div>
        </div>
    )
}
