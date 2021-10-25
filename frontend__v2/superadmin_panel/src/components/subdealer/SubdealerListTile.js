import React from 'react'
import { Link } from 'react-router-dom'

export default function SubdealerListTile({ subdealer }) {
    return (
        <Link to={'/subdealer/' + subdealer.id} className='list-group-item list-group-item-action'>
            <div className="d-flex w-100 justify-content-between">
                <h5 className="mb-1">{subdealer.user.name} ({subdealer.is_active ? "Active" : "Disabled"}) </h5>
                <small className='badge text-dark'>{subdealer.subdealer_code}</small>
            </div>
            <p className="mb-1 text-secondary">
                Orders : {subdealer.carts.length} <br />
                Products : {subdealer.products.length} <br />
                Staff : {subdealer.staff.length}
            </p>
        </Link>
    )
}
