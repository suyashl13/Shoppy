import React from 'react'
import { Link } from 'react-router-dom'

export default function SubdealerOrders({ orders }) {
    return (
        orders?.length == 0 ?
            <center className='m-5 p-4'> <h4 className='text-muted'>No orders.</h4> </center>
            : <ol className='list-group list-group-numbered'>
                {orders?.map((order, index) => <SubdealerOrderTile key={index} order={order}
                />)}
            </ol>
    )
}

const SubdealerOrderTile = ({ order }) => {
    return <li className='list-group-item d-flex justify-content-between align-items-start'>
        <div className="ms-2 me-auto">
            <div className="fw-bold">
                {order.user?.name ?
                    <Link to={`/orders/${order?.id}`} className='text-decoration-none'>{order.user?.name}</Link>
                    : "User Deleted"
                }
            </div>
            Items : {order.cart_items.length} <br />
            Subtotal : Rs.{order.subtotal} <br/>
        </div>
        <span className="badge bg-primary rounded-pill">{order.order_status}</span>
    </li>
}

