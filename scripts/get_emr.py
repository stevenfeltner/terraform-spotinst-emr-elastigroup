import json
import os
import sys
import boto3
import boto3.session
import logging
import click
import datetime
import time
from spotinst_sdk2 import SpotinstSession

# Configure the logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


@click.group()
@click.pass_context
def cli(ctx):
    ctx.obj = {}


@cli.command()
@click.argument('eg_id')
@click.option(
    '--token',
    required=False,
    help='Spotinst Token'
)
@click.pass_context
def get_id(ctx, **kwargs):
    """Get Elastilogs for Mr Scaler Elastigroup"""
    try:
        session = SpotinstSession(auth_token=kwargs.get('token'))
        ctx.obj['client'] = session.client("mrScaler_aws")
        result = ctx.obj['client'].get_emr_cluster(kwargs.get('eg_id'))
        logger.info('Session object created')
    except Exception as e:
        logger.debug('Error creating session object')
        logger.error(e, exc_info=True)
        sys.exit(1)

    id = result['id']
    logger.info(id)
    try:
        logger.info('Creating text file to store cluster_id')
        text_file = open("cluster_id.txt", "w")
        text_file.write(id)
        text_file.close()
    except Exception as e:
        print(e)
        sys.exit(1)


@cli.command()
@click.argument('eg_id')
@click.argument('emr_id')
@click.argument('region')
@click.pass_context
def get_dns(ctx, **kwargs):
    """Get EMR DNS ID for Mr Scaler Elastigroup"""

    @click.pass_context
    def get_state(ctx, eg_id, token):
        try:
            session = SpotinstSession(auth_token=token)
            logger.info('Session object created')
            ctx.obj['client'] = session.client("mrScaler_aws")
            logger.info(eg_id)
            result = ctx.obj['client'].get_emr_cluster(str(eg_id))
            state = str(result['state'])
            logger.info(f'Current state: {state}')
            return state
        except Exception as e:
            logger.debug('Error creating session object')
            logger.error(e, exc_info=True)
            sys.exit(1)

    try:
        session = boto3.session.Session(region_name=kwargs.get('region'))
        client = session.client('emr')
        logger.info('Boto3 Session object created')
    except Exception as e:
        logger.debug('Error creating boto3 session object')
        logger.error(e, exc_info=True)
        sys.exit(1)

    success = False
    while not success:
        if get_state(kwargs.get('eg_id'), kwargs.get('token')) == "terminated":
            sys.exit(1)
        result = client.describe_cluster(ClusterId=kwargs.get('emr_id'))
        dns_name = result.get('Cluster', {}).get('MasterPublicDnsName')
        if dns_name is not None:
            success = True
            try:
                logger.info('Creating text file to store cluster_ip')
                text_file = open("cluster_ip.txt", "w")
                text_file.write(dns_name)
                text_file.close()
                click.echo(json.dumps(dns_name))
            except Exception as e:
                print(e)
        else:
            time.sleep(10)


@cli.command()
@click.argument('region')
@click.pass_context
def list_clusters(ctx, **kwargs):
    """Get List of EMR IDS"""
    session = boto3.session.Session(region_name=kwargs.get('region'))
    client = session.client('emr')

    paginator = client.get_paginator('list_clusters').paginate(
        ClusterStates=['STARTING', 'BOOTSTRAPPING', 'RUNNING', 'WAITING'])

    for page in paginator:
        for item in page['Clusters']:
            print(item['Id'])


@cli.command()
def delete_id():
    """delete the file for cluster_id"""
    try:
        os.remove("cluster_id.txt")
    except Exception as e:
        print(e)
        sys.exit(1)


@cli.command()
def delete_dns():
    """delete the file for cluster_ip"""
    try:
        os.remove("cluster_ip.txt")
    except Exception as e:
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    cli()
