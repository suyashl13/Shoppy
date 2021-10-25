import React from 'react'
import { Link } from 'react-router-dom'

export default function StaffTab({ staff }) {
    return (
        <div>
            <div className="list-group">
                {
                    staff?.map(e => <StaffTile staff_person={e} />)
                }
            </div>
            <br />
        </div>
    )
}

const StaffTile = ({ staff_person }) => {
    return <li className='list-group-item d-flex justify-content-between'>
        <div className="div">
            <h6>{staff_person?.name}</h6>
            <span style={{ fontSize: '14px', color: 'grey' }}>{staff_person?.is_active ? 'Active' : 'Diabled'}</span>
        </div>
        <Link className='text-decoration-none' to={'/users/'+staff_person?.id}>See Deatils</Link>
    </li>
}