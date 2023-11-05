import { useEffect } from 'react'
import { Modal, Row, Col, Container, Form, FloatingLabel, Button } from "react-bootstrap"
import { useDispatch, useSelector } from "react-redux";
import { useForm } from "react-hook-form"
import { createProponent, viaCep, discount_amount } from "./actions"

const _ = require("lodash")

let FormEmployee = (props) => {
  const dispatch = useDispatch()
  const {title, subtitle, show, handleClose} = props
  const {register, handleSubmit, reset, getValues} = useForm()
  const proponents = useSelector(state => state.proponents)
  const { via_cep, discount_amount_preview } = proponents

  useEffect(() => {
    if(via_cep){
      reset(
        {
          addresses_attributes: [
            {
              zip: _.get(via_cep, 'cep'),
              address: _.get(via_cep, 'logradouro'),
              city: _.get(via_cep, 'localidade'),
              state: _.get(via_cep, 'uf'),
              district: _.get(via_cep, 'bairro'),
            }
          ]
        }
      );
    }
  }, [via_cep]);

  return (
    <Col>
      <Modal size="md" centered show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-vcenter">
            <blockquote className="blockquote mb-0">
              <p className="mb-0">{title}</p>
              <footer className="mt-0 blockquote-footer">{subtitle}</footer>
            </blockquote>
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="show-grid">
          <Container>
            <Form onSubmit={handleSubmit(data => dispatch([createProponent(data), reset(), handleClose()]))}>
              <Row>
                <Col className='mt-2'>
                  <FloatingLabel label="name">
                    <Form.Control placeholder="name" {...register('name')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2'>
                  <FloatingLabel label="taxpayer number">
                    <Form.Control placeholder="taxpayer number" {...register('taxpayer_number')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2'>
                  <FloatingLabel label="birthdate">
                    <Form.Control type="date" placeholder="birthdate" {...register('birthdate')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2'>
                  <FloatingLabel label={ discount_amount_preview === null ? "amount" : `discount amount: ${discount_amount_preview}` }>
                    <Form.Control type="amount" placeholder="amount" onMouseLeave={() => getValues('amount') === '' ? dispatch({type: "DISCOUNT_AMOUNT_PREVIEW", payload: null}) : dispatch(discount_amount(getValues('amount')))} {...register('amount')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2'>
                  <FloatingLabel label="contact">
                    <Form.Control placeholder="contact" {...register('contacts_attributes[0].number')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2'>
                  <FloatingLabel label="zip">
                    <Form.Control placeholder="zip" onMouseLeave={() => dispatch(viaCep(getValues('addresses_attributes[0].zip')))} {...register('addresses_attributes[0].zip')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2'>
                  <FloatingLabel label="address">
                    <Form.Control placeholder="address" {...register('addresses_attributes[0].address')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2 lg-6'>
                  <FloatingLabel label="district">
                    <Form.Control placeholder="district" {...register('addresses_attributes[0].district')} />
                  </FloatingLabel>
                </Col>
                <Col className='mt-2 lg-6'>
                  <FloatingLabel label="number">
                    <Form.Control placeholder="number" {...register('addresses_attributes[0].number')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Col className='mt-2 lg-6'>
                  <FloatingLabel label="state">
                    <Form.Control placeholder="state" {...register('addresses_attributes[0].state')} />
                  </FloatingLabel>
                </Col>
                <Col className='mt-2 lg-6'>
                  <FloatingLabel label="city">
                    <Form.Control placeholder="city" {...register('addresses_attributes[0].city')} />
                  </FloatingLabel>
                </Col>
              </Row>
              <Row>
                <Button className="mt-3" variant="success" type="submit">Hire</Button>
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

export default FormEmployee;
