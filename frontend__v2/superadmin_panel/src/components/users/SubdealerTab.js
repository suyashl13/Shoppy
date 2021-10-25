import React from 'react'
import { Link } from 'react-router-dom'

export default function SubdealerTab({ subdealers }) {
    return (
        <>
            <ul className="list-group">
                {
                    subdealers?.map((element, index) => <SubdealerTile key={index} subdealer={element} />)
                }
            </ul>
        </>
    )
}

const SubdealerTile = ({ subdealer: subdealer_user }) => {
    return <li className='list-group-item justify-content-between d-flex'>
        <div>
            <h6 className='mb-2'>{subdealer_user.name} ({subdealer_user.id})</h6>
        </div>
        <Link to={'/redirectsubdealerbyuid/' + subdealer_user.id} className='text-decoration-none'>See Subdealer Details</Link>
    </li>
}

