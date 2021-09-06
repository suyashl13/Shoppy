import React from 'react'
import { Link } from 'react-router-dom'

export default function SubdealerStaff(props) {
    const {staff} = props
    return (
        <li className="list-group-item d-flex justify-content-between align-items-start">
        <div className="ms-2 me-auto">
          <div className="fw-bold">{staff.name} ({staff.is_active ? 'Active' : 'Disabled'})</div> 
            Phone : {staff.phone}<br />
            <Link to={'/profile/staff/' + staff.id} className='btn btn-sm btn-primary mt-2 text-light' >Edit Staff</Link>
        </div>
        <span className="badge bg-primary ml-1"></span>
      </li>
    )
}
