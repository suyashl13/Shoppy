import React from 'react'
import { Link } from 'react-router-dom'

export default function SubdealerStaff({ staff }) {
    return (
        staff?.length == 0 ?
            <center className='m-5 p-4'> <h4 className='text-muted'>No staff.</h4> </center>
            :
            <div>
                <ul className="list-group">
                    {
                        staff?.map((staff_person, index) => {
                            return <StaffTile staff_person={staff_person} key={index} />
                        })
                    }
                </ul>
            </div>
    )
}

const StaffTile = ({ staff_person }) => {
    return <li className='list-group-item'>
        <h6><Link to='/' className='text-decoration-none'>{staff_person.name}</Link></h6>
        Phone : {staff_person.phone} <br />
        Active : {staff_person.is_active ? 'Yes' : "No"}
    </li>
}