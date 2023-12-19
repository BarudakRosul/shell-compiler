#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ�I`�B>C�p#՟2�o�jQU �6b��o�͔Mj�L2���4%:�Vт"^j�=Ō�ָMA�Q�1����BO�<�E�!�Ne�[	�B�X��9�r����S<>���[����P�]�Eky�>H�E���y}������/}���a��Qn�M�g뚉.1˘�e��n�51~;���)6�+;��F������?��
}WR�Kf�wRfZĆ��<Q弈@�~�J�}�HUe.�X��ˈa.�Ɩg�����:$��U6W�3�JBw���&L%!��Θ�Ѥ��AA��s�J{�mt
�Z�������4�}��l��ƙ�A�I��������|����i.�din븠��̟�3jCnt�⪪�zz�GX9`��iEW�gJ���=`{}CRЗWs���6`(G*nt����_\z�3�Ԕ���#��ע�l�R? �ݎמ`F���I��`	�Ȇ�Ox]�������R�B>z=m��>Z����\ת��� 4��?B�sg�]�{�tc�[�~G��������.s-w�����׃���������':.6C�5�v/����;�� �� �n0��+��lЮ��e�/�!77�����_��3�&��(�[|�N��������py���.���D[��~�\S����;"0�ep�1/by��u�[hy6�X/�b<�m��7�?C2���_T!�tZΘ:g���݌���J��Aل�@1=]E�NV��#{��: .VB�Y�\o�8z���Nk�8�{Q�X�U����Rkdo��ny�۵N]L��� O/������w�<�c�ڭ�%��$�m�:�x��5�rZO��.2gt�!������uj���QoT)��|W9�:�B΋x��)#����?x���B�+_QCh(�����y�ܔZ����ә^@eIpx�88�k�ڵC�?�+"}� ����pq����2y��_}�%�P��у�A��H ��U����q.9���齠���_�eէhD�	ޜ*�g��~Yj�#}*N��*�6���R�?�p#�]�9;"$Џ�5D��1�l�Yy�v?�+E����� ��7xȗ��9	�s4���f�;�	(u����X=�W�*B�ztu9y_�O��KQq���H��'n:��Cgƹ|p}.Db�66�<"���>y�#1�,�;�U��[Z�=F$�!�Q����d<��_����h�Q������B�i�aespJҾ0�Vh=���
e���'Kv��<�٨��@͛��EO�#�-r��gԟo�������[������
�Ɛ����n������]���݁��k�c��>�駜!�<�ˁ��Q����C��� zB��ċ�p��@�����7�X�f.4^C�\�6�ˬ0
�z����c칙\�j�Ő|\f��������W�Fg[��ۭ�=�����k0i1�6�+��Wr���e���������$'Y�w��bd�=�J����LC��4Ij�����m�I@H��u� ���*�	ԹNk�կ�+zb]KH�<>*�����ⶆ`�՚�$.�m�?��`�6L��Q�`����]�ugkĐ�:L���k�Y�cƖ|^q��Lt���?�r�k�։����6p2�p��4����e����u��A��G�>s� 
�7d]�Q���i񭣟,�Z�{9����\|�U�P���y�&&�@eYhю���6I��Rs��6�C�S;(M6�F�sU	Bm�O.E�r�"l"�F!��ql�OG�)��SBx�HZ�M�S�m�Գg��2q(d��6���+��.D���K�o.����k� )X�!͔�S1k���v�ȡf��xA� @]}$��)�e�ME����.�Z/z�9�#�,�ඹ���\��Ŕ�-��r|(�z�+�A��<?h`���[p.� �A0���1�ܙ#��ⶋ���;YS�3�"���-�qK���i_9M6}Jc֔��*��.����6<�$������j�n������f&8*e!���xkK��� Y���;�gBc}�AĜ��d<f����81ȩ͘fb���gg�	Jb��G���Om?�藈0S��?/HBr+�,mm���t�Q1EҠ����^<׹fa&��W�˓E�a0�=	�*Ll�+��y��"�@�|��o�.�o�7���善��?S�����A u4]vE����I踶�����kM@;���j���}׬��D�̿�)y�BZ��r����L$���QO( ֚YD��[���nFp���|�zUz�h���c,9��
{i>�;u�-Y¤���Z,w��\��
|÷)�Xd���~;�\���SU���2�B�Fv$M�u~��u����8�G��>����Q�5�ֱ1��x�i첵�
��`����)�ɟ5��&'�@��o̻SI7t	V3�P�m)�(ڥ�sJ�Wg�7�B_Ec�zc�s_?�0��N/Jv��,q�_�;�Y{�E^οH{̋��J�|J"��m()m�<�W�qێ�O��1a>E%:�g�#q/�m]�f���c,�):x��NKջ(w �Ň!}���y�J�|"��Nw����h��w��Z���[	��������#�d�K��fSd/ޫ��+S�� {���l�پ��}N�q��WEU��I��f'�^	2�xy��/1�Z����[؇d����R�҃1��/ְU�e�e�y='���:�������n�P ��i[h͟�y�̹8�o�X#�P�?$1�3�q�_�x���)+d94�_�\"~p�;���vM#�%�qH^��ʯQ�� .�`7���_G�-\(�V#�P\��=��&+��C�c �*ws���w9\�O��?R���Q@�JG�uc�8IO��)�1������*�P����^)��E� ]>���X�k�d���^d�:Ś�̆4�������E3��u�����~>���=}:=�s O�Y�#�J���]=.�:�ڎe�N\͵�P&ߕ��i���6���s��!�i��Rbu]PI��'�5���*��q0�3�Y���R��<�e�/쒺�E�rI@���UG����z�u��T~xngS`f�����O�D�0۴�kx)%k�M� F��B��0R!�&E��%Ԋ6�Y���)cP�uϢlwR��yF:� �I/y�B��\�NEdDhye�[��WA��
鞈rI����0
.�u�_�Y�5 XgZi%mQ�мj%�I���P�7�#�,뮾]?�7���ͳ�)��,zgh5�n��3�оk��NG9*�8���k�$�fI/}3��U��{뮝�����O,#̂׌�YE�H��X�L���C��Q ��źp��w�}Qg;<��r��N�aD����S���Nd��-�����l���w�T�~��Om?j�sEs�w���k�����^�	&�A�B��Vz
X�эa�b����.C��F��FE Gf'Q��N(cJ�n�NqjȀ�T,9J_������3�~$�����J)bq���D�?��D���MϺ}�X����6.��^��rQ%j �GRh�Z�F3{P>胾������i��A�L.��e�O3)���K-~�3@��2%�5�S�������O�]!�h�r��i�@�NdP�#���Riۛ~��WI�A��n�`!u'�}�ϗj=G-�_S l88����F��by������8^�����d�~�<M�|Wp��I�hsQ�Rx>��T�����r/3o�@5"�>#7FW�h�yi�v��Νwey�8�J��9�
׫�D!�z\��~�dh.��S��,|	Z$�vx���U^��?g&螟��W���G����ZT�;��`��X��KIeP\D���M���v㿸�'�wK��(�����v�d�BgB�(��V��^�${�LO1�NL�"s�����<���u Wh�(��o7~�lK��[����4�nO���z���˩/�à��|����=�=TJ�1%��#���C>P�	%�i���1%�=ufI�������z?Hr�&x�����c�ͼ��n)��#��|E������a�T������Cր� ��G�@���x21r�m�g���N�V�6U���<�-��z 