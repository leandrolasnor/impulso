import { useEffect } from 'react'
import { updateAmount, discount_amount } from "./actions"
import { Modal, Card, Row, Col, Container, Form, Button, FloatingLabel } from "react-bootstrap"
import { useDispatch, useSelector } from "react-redux";
import { useForm } from "react-hook-form"

let FormAmount = (props) => {
  const dispatch = useDispatch()
  const {title, show, handleClose} = props
  const { name, id, amount } = props.show
  const {register, handleSubmit, reset, getValues} = useForm()
  const proponents = useSelector(state => state.proponents)
  const { discount_amount_preview } = proponents

  useEffect(() => {
    reset({ amount: amount });
    amount === '' ? dispatch({type: "DISCOUNT_AMOUNT_PREVIEW", payload: null}) : dispatch(discount_amount(amount))
  }, [name]);

  return (
    <Col>
      <Modal size="md" centered show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-vcenter">
            <blockquote className="blockquote mb-0">
              <p className="mb-0">{title}</p>
              <footer className="mt-0 blockquote-footer">{name}</footer>
            </blockquote>
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="show-grid">
          <Container>
            <Form onSubmit={handleSubmit(data => dispatch([updateAmount({...data, id: id}), reset(), handleClose()]))}>
              <Row>
                <Card>
                  <Card.Body>
                    <Form.Group>
                      <Row>
                        <Col>
                          <Form.Group>
                            <FloatingLabel label={ discount_amount_preview === null ? "amount" : `discount amount: ${discount_amount_preview}` }>
                              <Form.Control placeholder="amount" onMouseLeave={() => getValues('amount') === '' ? dispatch({type: "DISCOUNT_AMOUNT_PREVIEW", payload: null}) : dispatch(discount_amount(getValues('amount')))} {...register('amount')} />
                            </FloatingLabel>
                          </Form.Group>
                        </Col>
                      </Row>
                    </Form.Group>
                  </Card.Body>
                </Card>
              </Row>
              <Row>
                <Button className='mt-3' variant="success" type="submit">Update Amount</Button>
              </Row>
            </Form>
          </Container>
        </Modal.Body>
        <Modal.Footer>
        </Modal.Footer>
      </Modal>
    </Col>
  )
}

export default FormAmount;
