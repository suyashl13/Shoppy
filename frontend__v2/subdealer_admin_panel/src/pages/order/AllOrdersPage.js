import React, { useContext } from 'react'
import { Link } from 'react-router-dom';
import { orderContext } from '../../contexts/OrderContext'

export default function AllOrdersPage() {

    const { orders } = useContext(orderContext);

    return (
        <div className='container'>
            <div className='m-5'>
                <center><h3>All Orders</h3></center>
                <br />
                <ul className="list-group">{
                    orders?.map((e, i) =>
                        <Link key={i} to={`/orders/${i}`} className="list-group-item list-group-item-action" aria-current="true">
                            <div className="d-flex w-100 justify-content-between">
                                <h5 className="mb-1">{e.user.name}</h5>
                                <small>₹ {e.subtotal}</small>
                            </div>
                            <p className="mb-1">{e.user.address}</p>
                            <small><span className='badge bg-primary'>{e.order_status}</span> <br />
                            {e.cart_items.length} Items 
                            </small>
                        </Link>
                    )
                }</ul>
            </div>
        </div>
    )
}
