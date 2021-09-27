import React, { useContext, useState } from 'react'
import { Link } from 'react-router-dom';
import { orderContext } from '../../contexts/OrderContext'

export default function AllOrdersPage() {

    const { orders } = useContext(orderContext);

    const [filteredOrders, setFilteredOrders] = useState(...orders)

    const setOrdersAccordingToRangeDates = () => {
        var fromDate = document.getElementById('from-date')
        var toDate = document.getElementById('to-date')
        console.log(toDate)
    }

    
    return (
        <div className='container'>
            <div className='m-5'>
                <center><h3>All Orders</h3></center>
                <div className="row justify-content-left">
                    <div className="col-4">
                        <label htmlFor="form-date">From</label>
                        <input type="date" id='form-date' className='form-control' />
                    </div>
                    <div className="col-4"><label htmlFor="to-date">To</label>
                        <input type="date" id='to-date' onChange={e=>{console.log(e.target.value)}} className='form-control' />
                    </div>
                    <div className="col-4"><label htmlFor="cust-date">Custom Date</label>
                    <button onClick={e=>{setOrdersAccordingToRangeDates()}} >Set Range</button>
                        {/* <input type="date" id='cust-date' className='form-control' /> */}
                    </div>
                </div>
                <hr />
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
