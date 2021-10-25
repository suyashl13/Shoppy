import React from 'react'
import { Link } from 'react-router-dom'

export default function ClientTab({ clients }) {
    return (
        <>
            <ul className="list-group">
                {clients?.map((e, i) => <ClientUserTile client={e} key={i} />)}
            </ul>
        </>
    )
}

const ClientUserTile = ({ client }) => <li className='list-group-item d-flex justify-content-between'>
    <div>
        <h6>{client?.name} (UID : {client?.id})</h6>
        <span className='text-secondary'>Orders : {client?.carts.length}</span>
    </div>
    <div className="justify-content-end">
        <Link to={`/users/${client?.id}`} className='text-decoration-none'>See Details</Link><br />
    </div>
</li>

