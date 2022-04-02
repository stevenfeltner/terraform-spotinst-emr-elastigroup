import json
import os
import boto3
import boto3.session
import click
import datetime
import time
from spotinst_sdk2 import SpotinstSession


@click.group()
@click.pass_context
def cli(ctx, *args, **kwargs):
    ctx.obj = {}


@cli.command()
@click.argument('eg_id')
@click.option(
    '--token',
    required=False,
    help='Spotinst Token'
)
@click.pass_context
def get_logs(ctx, *args, **kwargs):
    """Get Elastilogs for Mr Scaler Elastigroup"""
    time.sleep(20)
    epoch_to = int(datetime.datetime.now().timestamp() * 1000)
    epoch_from = epoch_to - 10000000

    session = SpotinstSession(auth_token=kwargs.get('token'))
    ctx.obj['client'] = session.client("elastigroup_aws")
    result = ctx.obj['client'].get_elastilog(kwargs.get('eg_id'), epoch_from, epoch_to)
    success = False
    for x in result:
        if success:
            break
        elif x.get('message').find("j-") > 0:
            split = x.get('message').split()
            for y in split:
                if success:
                    break
                elif y.startswith("j-"):
                    cluster = str(y)
                    text_file = open("cluster_id.txt", "w")
                    text_file.write(cluster)
                    text_file.close()
                    click.echo(cluster)
                    success = True


@cli.command()
@click.argument('emr_id')
@click.argument('region')
@click.pass_context
def get_dns(ctx, *args, **kwargs):
    """Get EMR DNS ID for Mr Scaler Elastigroup"""
    session = boto3.session.Session(region_name=kwargs.get('region'))
    client = session.client('emr')

    success = False
    while not success:
        result = client.describe_cluster(ClusterId=kwargs.get('emr_id'))
        dns_name = result.get('Cluster', {}).get('MasterPublicDnsName')
        if dns_name is not None:
            success = True
            text_file = open("cluster_ip.txt", "w")
            text_file.write(dns_name)
            text_file.close()
            click.echo(json.dumps(dns_name))
        else:
            time.sleep(10)


@cli.command()
@click.argument('region')
@click.pass_context
def list_clusters(ctx, *args, **kwargs):
    """Get List of EMR IDS"""
    session = boto3.session.Session(region_name=kwargs.get('region'))
    client = session.client('emr')

    paginator = client.get_paginator('list_clusters').paginate(
        ClusterStates=['STARTING', 'BOOTSTRAPPING', 'RUNNING', 'WAITING'])

    for page in paginator:
        for item in page['Clusters']:
            print(item['Id'])


@cli.command()
def delete_id(*args, **kwargs):
    """delete the file for cluster_id"""
    try:
        os.remove("cluster_id.txt")
    except:
        exit()


@cli.command()
def delete_dns(*args, **kwargs):
    """delete the file for cluster_ip"""
    try:
        os.remove("cluster_ip.txt")
    except:
        exit()


if __name__ == "__main__":
    cli()
