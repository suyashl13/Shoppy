import React from 'react'
import { useContext } from 'react/cjs/react.development'
import { orderContext } from '../../contexts/OrderContext'

export default function HomePage() {

    const { orders, setOrders } = useContext(orderContext)

    const getOrdersSubtotal = () => {

        let total = {
            deliveredSubtotal: 0,
            deliveredCount: 0,
            notDeliveredTotal: 0,
            notDeliveredCount: 0,
        };
        orders?.forEach(element => {
            if (element.is_delivered) {
                total.deliveredSubtotal = total.deliveredSubtotal + parseInt(element.subtotal)
                total.deliveredCount = total.deliveredCount + 1
            } else {
                total.notDeliveredTotal = total.notDeliveredTotal + parseInt(element.subtotal)
                total.notDeliveredCount = total.notDeliveredCount + 1
            }
        });
        return total;
    }



    return (
        <div className='container p-4'>
            <div className="row mb-4">
                <div className="col-sm-12 col-md-3">
                    <div className="info-card bg-info shadow mt-2">
                        <span className='info-card-count'>{getOrdersSubtotal().deliveredCount}</span>
                        <center className='info-card-title'>Delivered Orders</center>
                    </div>
                </div>
                <div className="col-sm-12 col-md-3">
                    <div className="info-card bg-warning shadow mt-2">
                        <span className='info-card-count'>{getOrdersSubtotal().notDeliveredCount}</span>
                        <center className='info-card-title'>Pending Orders</center>
                    </div>
                </div>
                <div className="col-sm-12 col-md-3">
                    <div className="info-card bg-info shadow mt-2">
                        <span className='info-card-count'>₹ {getOrdersSubtotal().deliveredSubtotal}</span>
                        <center className='info-card-title'>Completed Subtotal</center>
                    </div>
                </div>
                <div className="col-sm-12 col-md-3">
                    <div className="info-card bg-warning shadow mt-2">
                        <span className='info-card-count'>₹ {getOrdersSubtotal().notDeliveredTotal}</span>
                        <center className='info-card-title'>Pending Amount</center>
                    </div>
                </div>
            </div>

            

            {/* <h3 className='mt-5'>Important Links</h3>
            <hr /> */}
            
        </div>
    );
}
