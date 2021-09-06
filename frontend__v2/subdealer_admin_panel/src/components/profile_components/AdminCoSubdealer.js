import React from 'react'
import { Link } from 'react-router-dom'

export default function AdminCoSubdealer(props) {

    const {co_subdealer} = props

    return (
        <li className="list-group-item d-flex justify-content-between align-items-start">
        <div className="ms-2 me-auto">
          <div className="fw-bold">{co_subdealer.user.name} ({co_subdealer.is_active ? 'Active' : 'Disabled'})</div> 
            Phone : {co_subdealer.user.phone}<br />
            Assigned Pincodes : {co_subdealer.pincodes} <br />
            <Link to={'/profile/co_subdealer/' + co_subdealer.id} className='btn btn-sm btn-primary mt-2 text-light' >Edit Subdealer</Link>
        </div>
        <span className="badge bg-primary ml-1">#{co_subdealer.subdealer_code}</span>
      </li>
    )
}
